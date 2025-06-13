variable "subnets" {
  description = "Subnets to place the ALB in"
  type        = list(string)
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
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
    service_name = string
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
