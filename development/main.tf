provider "aws" {
  profile = "default"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {
    bucket = "nevvi-development-terraform-remote-state"
    key    = "terraform-state"
    region = "us-east-1"
  }
}

module "website" {
  source = "../modules/website"
  site_name = "development.nevvi.net"
  site_zone = "nevvi.net."
  site_cert_name = "*.nevvi.net"
  cloudfront_cname_aliases = ["development.nevvi.net"]
  environment = var.environment
  backend_domain = "api.development.nevvi.net"
}

module "user_pool" {
  source = "../modules/authentication"
  user_pool_name = "nevvi-development-public-users"
  pre_signup_function_name = "authentication-development-preSignUpTrigger"
}

module "user_table" {
  source = "../modules/database"
  table_name = "user-dev"
}