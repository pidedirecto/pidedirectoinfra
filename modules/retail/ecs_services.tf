resource "aws_ecs_task_definition" "retail" {
  for_each = { for image in var.images : image.service_name => image }

  family = "ambit-retail-${each.value.service_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"

  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = each.value.service_name
      image     = "${aws_ecr_repository.retail.repository_url}:${each.value.tag}"
      cpu       = 0
      essential = true
      portMappings = [
        {
          name          = "${each.value.service_name}-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "STAGE"
          value = "prod"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs[each.value.service_name].name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = each.value.service_name
        }
      }
      mountPoints    = []
      volumesFrom    = []
      systemControls = []
    }
  ])
}

resource "aws_ecs_service" "retail" {
  for_each = { for image in var.images : image.service_name => image }

  name            = each.value.service_name
  cluster         = aws_ecs_cluster.retail.id
  task_definition = aws_ecs_task_definition.retail[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.retail_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.retail[each.key].arn
    container_name   = each.value.service_name
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener_rule.retail
  ]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "retailEcsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  for_each          = { for image in var.images : image.service_name => image }
  name              = "/aws/ecs/${each.key}"
  retention_in_days = 7
}
