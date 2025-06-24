
variable "aws_profile" {
  description = "Profile to create AWS infra"
  type        = string
}


variable "subnets" {
  description = "Subnets to place the ALB in"
  type        = list(string)
}


variable "vpc_id" {
  type        = string
  description = "VPC ID for target groups"
}


variable "security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
  default = "test"
}

data "aws_ssm_parameter" "GRAFANA_CLOUD_API_KEY" {
name = "/pidedirectoinfra/prod/GRAFANA_CLOUD_API_KEY"
with_decryption = true
}

data "aws_ssm_parameter" "RETAIL_PHP_LOGIN_DOCKERIMAGE_TAG" {
  name = "/pidedirectoinfra/prod/RETAIL_PHP_LOGIN_DOCKERIMAGE_TAG"
  with_decryption = true
}

data "aws_ssm_parameter" "RETAIL_PHP_BACKOFFICE_DOCKERIMAGE_TAG" {
  name = "/pidedirectoinfra/prod/RETAIL_PHP_BACKOFFICE_DOCKERIMAGE_TAG"
  with_decryption = true
}

data "aws_ssm_parameter" "RETAIL_PHP_BILLING_DOCKERIMAGE_TAG" {
  name = "/pidedirectoinfra/prod/RETAIL_PHP_BILLING_DOCKERIMAGE_TAG"
  with_decryption = true
}

data "aws_ssm_parameter" "RETAIL_PHP_DOCKERIMAGE_TAG" {
  name = "/pidedirectoinfra/prod/RETAIL_PHP_DOCKERIMAGE_TAG"
  with_decryption = true
}

data "aws_ssm_parameter" "RETAIL_PHP_NOTIFICATIONS_DOCKERIMAGE_TAG" {
  name = "/pidedirectoinfra/prod/RETAIL_PHP_NOTIFICATIONS_DOCKERIMAGE_TAG"
  with_decryption = true
}