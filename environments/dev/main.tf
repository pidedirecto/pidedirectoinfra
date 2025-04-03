terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }
  }

  required_version = ">= 1.2.0"
}

module "storage" {
  source              = "../../modules/storage"
  temp_bucket_name    = "temp.dev.ambit.la"
  private_bucket_name = "files.dev.ambit.la"
}