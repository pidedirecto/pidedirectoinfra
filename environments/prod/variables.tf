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