# TODO: 
# add vpc endpoints for AWS session manager to allow access to the bastion host (EC2 instance) without public IPs
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "6.6.1"

  vpc_id             = var.vpc_id
  security_group_ids = [var.vpc_endpoint_security_group_id]

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
    }
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
    }
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
    }
  }
}