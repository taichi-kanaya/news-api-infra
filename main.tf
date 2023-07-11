terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6.2"
    }
  }
  required_version = ">= 1.5.2"
}

module "s3_module" {
  source = "./modules/s3"
}

module "vpc_module" {
  source = "./modules/vpc"
}

module "cloud_watch_module" {
  source = "./modules/cloud_watch"
}
