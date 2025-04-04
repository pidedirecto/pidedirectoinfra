variable "temp_bucket_name" {
  description = "Name of temp bucket"
  type        = string
}

variable "private_bucket_name" {
  description = "Private name of bucket"
  type        = string
}

variable "custom_domain_for_cloudfront" {
  description = "Custom domain for cloudfront"
  type        = string
}

variable "letseat_hosted_id" {
  description = "Hosted ID for letseat.mx"
  type        = string
  default     = "Z337NEM1AXW42" // TODO: pass through variable
}