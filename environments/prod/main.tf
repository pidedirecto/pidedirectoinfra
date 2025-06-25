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
  grafana_cloud_api_key = data.aws_ssm_parameter.GRAFANA_CLOUD_API_KEY.value
}

module "retail" {
  source          = "../../modules/retail"
  aws_profile       = "pidedirecto"
  cluster_name      = "retail"
  images = [{
    name             = "retail"                  # Docker repo name
    tag              =  data.aws_ssm_parameter.RETAIL_SERVER_DOCKER_IMAGE_TAG.value  # When release a new version, tag is updated and this cause terraform to update the image on ecs getting new changes
    path             = "/retail*"
    service_name     = "retail-php"          # Unique service/task/target name
    },
    {
      name             = "retail"                  # Docker repo name
      tag              =  data.aws_ssm_parameter.RETAIL_BILLING_SERVER_DOCKER_IMAGE_TAG.value  # When release a new version, tag is updated and this cause terraform to update the image on ecs getting new changes
      path             = "/billing*"
      service_name     = "retail-php-billing"          # Unique service/task/target name
    },
    {
      name             = "retail"                  # Docker repo name
      tag              =  data.aws_ssm_parameter.RETAIL_LOGIN_SERVER_DOCKER_IMAGE_TAG.value  # When release a new version, tag is updated and this cause terraform to update the image on ecs getting new changes
      path             = "/login*"
      service_name     = "retail-php-login"          # Unique service/task/target name
    },
    {
      name             = "retail"                  # Docker repo name
      tag              =  data.aws_ssm_parameter.RETAIL_ECOMMERCE_SERVER_DOCKER_IMAGE_TAG.value  # When release a new version, tag is updated and this cause terraform to update the image on ecs getting new changes
      path             = "/backoffice*"
      service_name     = "retail-php-backoffice"          # Unique service/task/target name
    },
    {
      name             = "retail"                  # Docker repo name
      tag              =  data.aws_ssm_parameter.RETAIL_NOTIFICATION_SERVER_DOCKER_IMAGE_TAG.value  # When release a new version, tag is updated and this cause terraform to update the image on ecs getting new changes
      path             = "/notifications*"
      service_name     = "retail-php-notifications"          # Unique service/task/target name
    }
  ]
  security_group_id = var.security_group_id
  subnets = var.subnets
  vpc_id            = var.vpc_id
}