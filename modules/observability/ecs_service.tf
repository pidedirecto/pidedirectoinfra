resource "aws_ecs_service" "alloy_service" {
  name            = "grafana-alloy-service"
  cluster         = aws_ecs_cluster.grafana_alloy.id
  task_definition = aws_ecs_task_definition.alloy.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.alloy_sg.id]
  }
}