terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6.2"
    }
  }
  required_version = ">= 1.5.2"
}

module "route53_module" {
  source = "./modules/route53"
  tags   = var.tags
}

module "s3_module" {
  source = "./modules/s3"
  tags   = var.tags
}

module "vpc_module" {
  source = "./modules/vpc"
  tags   = var.tags
}

module "cloud_watch_module" {
  source = "./modules/cloud_watch"
  tags   = var.tags
}

module "ecr_module" {
  source = "./modules/ecr"
  tags   = var.tags
}
