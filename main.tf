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
  source      = "./modules/route53"
  app_name    = var.app_name
  domain_name = var.domain_name
}

module "s3_module" {
  source         = "./modules/s3"
  s3_backet_name = var.app_name
}

module "vpc_module" {
  source = "./modules/vpc"
}

module "security_group_module" {
  source                        = "./modules/security_group"
  vpc_id                        = module.vpc_module.vpc_id
  vpc_default_security_group_id = module.vpc_module.vpc_default_security_group_id
}

module "cloud_watch_module" {
  source = "./modules/cloud_watch"
}

module "ecr_module" {
  source              = "./modules/ecr"
  ecr_repository_name = var.app_name
}

module "iam_module" {
  source              = "./modules/iam"
  ecr_repository_name = var.app_name
}

module "alb_module" {
  source                = "./modules/alb"
  vpc_id                = module.vpc_module.vpc_id
  public_subnets        = module.vpc_module.public_subnets
  ssl_certificate_arn   = module.route53_module.ssl_certificate_arn
  alb_security_group_id = module.security_group_module.http_and_https_security_group_id
  app_name              = var.app_name
  domain_name           = var.domain_name
  public_hostzone_id    = module.route53_module.public_hostzone_id
}

module "ssm_module" {
  source = "./modules/ssm"
  parameter_map = [
    {
      name : "/${var.app_name}/env"
      type : "String"
      value : "prod"
    },
    {
      name : "/${var.app_name}/news-api-key"
      type : "SecureString"
      value : "dummy" # 手動でセットする
    },
    {
      name : "/${var.app_name}/sentry-dsn"
      type : "String"
      value : "https://6c53cd6e653444eeb0e48b54c2f1cbd6@o4505101788643328.ingest.sentry.io/4505593649496064"
    }
  ]
}

module "ecs_module" {
  source                      = "./modules/ecs"
  ecs_target_group_arn        = module.alb_module.ecs_target_group_arn
  app_name                    = var.app_name
  ecs_security_group_id       = module.security_group_module.app_security_group_id
  private_subnets             = module.vpc_module.private_subnets
  ecs_task_execution_role_arn = module.iam_module.ecs_task_execution_arn
  ecr_repository_url          = module.ecr_module.repository_url
  ecs_secrets = [
    {
      "name" : "APP_ENV",
      "valueFrom" : "/${var.app_name}/env"
    },
    {
      "name" : "NEWS_API_KEY",
      "valueFrom" : "/${var.app_name}/news-api-key"
    },
    {
      "name" : "SENTRY_DSN",
      "valueFrom" : "/${var.app_name}/sentry-dsn"
    }
  ]
}
