variable "temp_bucket_name" {
  description = "Name of temp bucket"
  type        = string
}

variable "public_bucket_name" {
  description = "Public name of bucket"
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
