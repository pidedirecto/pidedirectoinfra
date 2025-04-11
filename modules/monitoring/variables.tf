variable "environment" {
  description = "Deployment environment, e.g., dev, staging, prod"
  type        = string
}

variable "aws_region" {
  description = "Default AWS region"
  type        = string
}