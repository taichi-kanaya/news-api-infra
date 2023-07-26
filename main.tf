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
  source               = "./modules/route53"
  tags                 = var.tags
  public_hostzone_name = "attakait.com"
}

module "s3_module" {
  source         = "./modules/s3"
  tags           = var.tags
  s3_backet_name = "news-api"
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
  source              = "./modules/ecr"
  tags                = var.tags
  ecr_repository_name = "news-api"
}

module "iam_module" {
  source              = "./modules/iam"
  tags                = var.tags
  ecr_repository_name = "news-api"
}

module "alb_module" {
  source              = "./modules/alb"
  tags                = var.tags
  vpc_id              = module.vpc_module.vpc_id
  public_subnets      = module.vpc_module.public_subnets
  ssl_certificate_arn = module.route53_module.ssl_certificate_arn
}

