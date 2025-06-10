resource "aws_ecs_task_definition" "retail" {
  for_each = { for image in var.images : "${image.name}-${image.tag}" => image }

  family                   = "ambit-retail-php-task" # Use a static family or parameterize if needed
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # or parameterize if needed
  memory                   = "3072" # or parameterize if needed

  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = each.value.tag # You can use each.value.tag or each.value.container_name if you want
      image     = "${var.ecr_repo_url}:${each.value.tag}" # e.g. "264272770386.dkr.ecr.us-east-1.amazonaws.com/retail:retail-billing-php"
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

  # If you need to use volumes, add them here:
  # volumes = []

  tags = var.common_tags
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
