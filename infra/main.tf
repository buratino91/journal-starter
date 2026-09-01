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
  ec2_security_group_id        = module.ec2_security_group.ec2_security_group_id
  endpoint_SG_id               = module.endpoint_security_group.endpoint_SG_id
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
  POSTGRES_DB            = var.POSTGRES_DB   # passed via tfvars file
  POSTGRES_USER          = var.POSTGRES_USER # passed via tfvars file
}

module "iam_roles" {
  source = "./modules/Security"
}

# So that terraform wont need to manage this as we do not want it to be deleted when we destroy the stack
data "aws_ecr_repository" "journal-app" {
  name = "l2c/journal-app"

}

module "eks" {
  source            = "./modules/EKS"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  #  The left-side name in the module call must match a variable declared inside that module
  node_security_group_id = module.api_server_security_group.api_server_security_group_id
}

module "ec2_security_group" {
  source = "./modules/Security/ec2_SG"
  vpc_id = module.vpc.vpc_id
}

module "ec2-instance" {
  source                 = "./modules/EC2"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.ec2_security_group.ec2_security_group_id]
  POSTGRES_USER          = var.POSTGRES_USER
  POSTGRES_DB            = var.POSTGRES_DB
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
  private_subnet_ids = module.vpc.private_subnets
}

output "instance_id" {
  value = module.ec2-instance.instance_id
}

# S3 bucket for delivering database setup file to EC2 instance via SSM
resource "aws_s3_bucket" "l2c_bucket" {
  bucket = "l2c-bucket"

  tags = {
    Name        = "l2c-bucket"
    Environment = "Dev"
  }
}

resource "null_resource" "upload_db_setup_file" {
  depends_on = [aws_s3_bucket.l2c_bucket]

  provisioner "local-exec" {
    command = <<EOT
      aws s3 cp ../database_setup.sql s3://${aws_s3_bucket.l2c_bucket.id}/database_setup.sql
    EOT
  }
}

# Provides an object resource for the EC2 instance 
resource "aws_s3_object" "db_setup_file" {
  bucket = aws_s3_bucket.l2c_bucket.id
  key    = "database_setup.sql"
  source = "${path.module}/../database_setup.sql"

  depends_on = [aws_s3_bucket.l2c_bucket]
}

// Pull file from S3 and run it on EC2 instance via SSM
resource "null_resource" "init_db" {
  depends_on = [aws_s3_object.db_setup_file, module.ec2-instance]

  provisioner "local-exec" {
    command = <<EOT
      aws ssm send-command \
        --instance-ids "${module.ec2-instance.instance_id}" \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=[
        "cd $HOME" && aws s3 cp s3://${aws_s3_bucket.l2c_bucket.id}/database_setup.sql .",
        "sudo dnf install -y postgresql18"
        ]'
    EOT
  }
}