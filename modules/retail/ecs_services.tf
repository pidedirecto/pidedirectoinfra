resource "aws_ecs_task_definition" "retail" {
  for_each = { for image in var.images : "${image.name}-${image.tag}" => image }

  family                   = "ambit-retail-php-task" # Use a static family or parameterize if needed
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # or parameterize if needed
  memory                   = "3072" # or parameterize if needed


  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = each.value.tag
      image     = "${aws_ecr_repository.retail.repository_url}:${each.value.tag}"
      cpu       = 0 # 0 for container means use task-level CPU
      essential = true
      portMappings = [
        {
          name          = "${each.value.tag}-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "STAGE"
          value = "dev"
        }
      ]
      mountPoints     = []
      volumesFrom     = []
      systemControls  = []
    }
  ])

}


resource "aws_ecs_service" "retail" {
  for_each = { for image in var.images : image.name => image } // this is looping on all images, for now its comment to only deploy only service (one deploy, one project)

  name            = each.value.tag
  cluster         = aws_ecs_cluster.retail.id
  task_definition = aws_ecs_task_definition.retail[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.retail[each.key].arn
    container_name   = each.value.tag  # Must match container name in task definition
    container_port   = 80            # Must match port container is exposing
  }

  depends_on = [
    aws_lb_listener_rule.retail
  ]

}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Effect = "Allow"
      Sid = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}