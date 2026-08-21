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
  source                       = "./modules/Security/db_SG"
  vpc_id                       = module.vpc.vpc_id
  api_server_security_group_id = module.api_server_security_group.api_server_security_group_id
  my_ip                        = var.my_ip
}

module "api_server_security_group" {
  source               = "./modules/Security/api_server_SG"
  db_security_group_id = module.db_security_group.db_security_group_id
  vpc_id               = module.vpc.vpc_id
}

module "rds" {
  source                 = "./modules/Database"
  db_subnet              = module.vpc.private_subnets
  vpc_id                 = module.vpc.vpc_id
  vpc_security_group_ids = [module.db_security_group.db_security_group_id]
  POSTGRES_DB            = var.POSTGRES_DB       # passed via tfvars file
  POSTGRES_PASSWORD      = var.POSTGRES_PASSWORD # passed via tfvars file
}

module "iam_roles" {
  source = "./modules/Security"
}

resource "aws_ecr_repository" "journal-app" {
  name = "l2c/journal-app"
  lifecycle {
    prevent_destroy = true
  }
}

module "eks" {
  source            = "./modules/EKS"
  vpc_id            = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  #  The left-side name in the module call must match a variable declared inside that module
  #  modules/EKS/variables.tf: variable "api_server_security_group_id" { ... }
  # root main.tf: module "eks" { api_server_security_group_id = module.api_server_security_group.api_server_security_group_id }
  node_security_group_id = module.api_server_security_group.id
}

module "ec2_security_group" {
  source = "./modules/Security/ec2_SG"
  vpc_id = module.vpc.vpc_id
}

module "ec2-instance" {
  source                 = "./modules/EC2"
  subnet_id              = module.vpc.private_subnets
  vpc_security_group_ids = [module.ec2_security_group.ec2_security_group_id]
}

module "endpoint_security_group" {
  source                       = "./modules/Security/vpc_endpoint_SG"
  vpc_id                       = module.vpc.vpc_id
  referenced_security_group_id = module.ec2_security_group.ec2_security_group_id
}

module "vpc_endpoints" {
  source             = "./modules/VPC_endpoints"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.endpoint_security_group.endpoint_SG_id]
}