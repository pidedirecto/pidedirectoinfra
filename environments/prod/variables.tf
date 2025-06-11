variable "region" {
  description = "Default region for provider"
  type        = string
}

variable "aws_profile" {
  description = "Profile to create AWS infra"
  type        = string
}

variable "grafana_cloud_api_key"{
  description = "grafana cloud api key"
  type        = string
  sensitive = true
}

variable "subnets" {
  description = "Subnets to place the ALB in"
  type        = list(string)
}


variable "vpc_id" {
  type        = string
  description = "VPC ID for target groups"
}


variable "images" {
  description = "List of services to deploy"
  type = list(object({
    name = string
    tag  = string
    path = string
  }))
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}
