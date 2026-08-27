module "db_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "DB-SG"
  description = "Security group for database instances"
  vpc_id      = var.vpc_id

  ingress_rules = {
    all_from_api_servers = {
      ip_protocol                  = "-1"
      referenced_security_group_id = var.api_server_security_group_id
      description                  = "All traffic from API servers"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
    postgres_from_ec2 = {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      referenced_security_group_id = var.ec2_security_group_id
      description = "Allow PostgreSQL from EC2"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic for downloads and updates"
    }
    https_to_endpoint_sg = {
      ip_protocol = "tcp"
      from_port = 443
      referenced_security_group_id = var.endpoint_SG_id
      description = "allow HTTPS to VPC endpoints security group for SSM"
    }
  }

  tags = {
    Terraform = "true"
  }
}