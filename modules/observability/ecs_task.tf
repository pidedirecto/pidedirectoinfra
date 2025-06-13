resource "aws_ecs_task_definition" "alloy" {
  family                   = "grafana-alloy-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = aws_ecr_repository.grafana_alloy.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 4318
          hostPort      = 4318
        },
        {
          containerPort = 12345
          hostPort      = 12345
        }
      ]
      environment = [
        { name = "GRAFANA_CLOUD_OTLP_ENDPOINT", value = "https://otlp-gateway-prod-us-east-2.grafana.net/otlp" },
        { name = "GRAFANA_CLOUD_INSTANCE_ID", value = "1235601" },
        { name = "GRAFANA_CLOUD_API_KEY", value = data.aws_ssm_parameter.GRAFANA_CLOUD_API_KEY.value }
      ]
    }
  ])
}
