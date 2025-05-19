variable "repository_name" {
  description = "Repository name in ECR for observability"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default = "dev"
}