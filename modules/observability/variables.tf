variable "repository_name" {
  description = "Repository name in ECR for observability"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "alloy_cluster_name" {
  description = "value for the cluster name"
  type        = string
}

variable "container_name" {
  description = "container name for grafana alloy"
  type        = string
  default     = "pidedirectoalloy"
}

variable "cpu" {
  description = "cpu for the container"
  type        = number
  default = 256
}

variable "memory" {
  description = "memory for the container"
  type        = number
  default = 512
}

variable "grafana_cloud_api_key"{
  description = "grafana cloud api key"
  type        = string
}

data "aws_ssm_parameter" "GRAFANA_CLOUD_API_KEY" {
  name = "/pidedirectoinfra/prod/GRAFANA_CLOUD_API_KEY"
  with_decryption = true
}