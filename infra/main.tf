terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

# modules here
module "vpc" {
  source = "./modules/VPC"
}

module "db_security_group" {
  source = "./modules/Security/db_security_group"
  vpc_id = module.vpc.vpc_id
  api_server_security_group_id = module.api_server_security_group.api_server_security_group_id
  my_ip = var.my_ip
}

module "api_server_security_group" {
  source = "./modules/Security/api_server_security_group"
  db_security_group_id = module.db_security_group.db_security_group_id
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/Database"
  db_subnet = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  vpc_security_group_ids = module.db_security_group.db_security_group_id
  POSTGRES_DB = var.POSTGRES_DB # passed via tfvars file
  POSTGRES_PASSWORD = var.POSTGRES_PASSWORD # passed via tfvars file
}