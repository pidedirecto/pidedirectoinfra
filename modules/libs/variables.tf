variable "domain_name" {
  description = "Domain name of Codeartifact repository"
  type        = string
  default = "pidedirecto"
}

variable "repository_name" {
  description = "Repository name in Codeartifact"
  type        = string
  default = "npm"
}

variable "aws_profile" {
  description = "Profile to create AWS infra"
  type        = string
}