variable "region" {
  description = "Default region for provider"
  type        = string
}

variable "aws_profile" {
  description = "Profile to create AWS infra"
  type        = string
}

variable "state_bucket_name" {
  type        = string
  description = "S3 bucket name for Terraform state"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for state locking"
}