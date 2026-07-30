module "db_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "DB-SG"
  description = "Security group for database instances"
  vpc_id      = var.vpc_id

  ingress_rules = {
    all_from_api_servers = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      referenced_security_group_id = var.api_server_security_group_id
      description = "All traffic from API servers"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
    allow_from_my_ip = {
      ip_protocol = "-1"
      cidr_ipv4   = var.my_ip # from terraform.tfvars
      description = "Allow all traffic from my IP address"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic for downloads and updates"
    }
  }

  tags = {
    Terraform   = "true"
  }
}