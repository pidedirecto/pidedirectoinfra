resource "aws_ecs_cluster" "grafana_alloy" {
  name = var.alloy_cluster_name
}