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
  source          = "../../modules/libs"
  domain_name     = "pidedirecto"
  repository_name = "npm"
  aws_profile     = var.aws_profile
}

module "pidedirectofileserver" {
  source                       = "../../modules/pidedirectofileserver"
  temp_bucket_name             = "temp.files.ambit.la"
  public_bucket_name           = "public.files.ambit.la"
  private_bucket_name          = "private.files.ambit.la"
  custom_domain_for_cloudfront = "files.ambit.la"
}

module "observability" {
  source          = "../../modules/observability"
  repository_name = "pidedirectoalloy"
  env             = "prod"
  alloy_cluster_name = "pidedirecto-alloy-cluster"
  grafana_cloud_api_key= var.grafana_cloud_api_key
}