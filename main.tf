provider "aws" {
  region = var.aws_region
}

# Use modules for better organization
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block        = var.vpc_cidr_block
  availability_zones    = var.availability_zones
  web_subnet_cidrs      = var.web_subnet_cidrs
  app_subnet_cidrs      = var.app_subnet_cidrs
  db_subnet_cidrs       = var.db_subnet_cidrs
  standby_subnet_cidrs  = var.standby_subnet_cidrs
  project               = var.project
  environment           = var.environment
  owner                 = var.owner
}

module "security" {
  source = "./modules/security"

  vpc_id                = module.vpc.vpc_id
  web_subnet_ids        = module.vpc.web_subnet_ids
  app_subnet_ids        = module.vpc.app_subnet_ids
  db_subnet_ids         = module.vpc.db_subnet_ids
  standby_subnet_ids    = module.vpc.standby_subnet_ids
  project               = var.project
  environment           = var.environment
  owner                 = var.owner
}

module "iam" {
  source = "./modules/iam"

  project               = var.project
  environment           = var.environment
  owner                 = var.owner
}

# You can add additional modules as needed, such as:
# module "ec2" {}
# module "rds" {}
# module "load_balancers" {}