variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

resource "aws_ecs_cluster" "retail" {
  name = var.cluster_name
}