terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }
  }

  required_version = ">= 1.2.0"
}

module "libs" {
  source = "../../modules/libs"
  domain_name = "pidedirecto"
  repository_name = "npm"
  aws_profile = var.aws_profile
}