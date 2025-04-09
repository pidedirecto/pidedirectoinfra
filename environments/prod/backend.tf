terraform {
  backend "s3" {
    bucket         = "terraform.state.ambit.la"
    key            = "ambit/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ambit-terraform-locks"
    encrypt        = true
    profile        = "pidedirecto"
  }
}