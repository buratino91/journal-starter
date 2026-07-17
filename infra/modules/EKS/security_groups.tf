# Security groups for eks api servers
module "api_server_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "eks-api-server-sg"
  description = "Security group for EKS API server"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    https = {
      from_port   = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from all"
    }
    http = {
      from_port   = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from all"
    }
    ssh = {
      from_port   = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "210.10.77.5/32"
      description = "SSH from my IP"
    }
    all_from_db_servers = {
      ip_protocol                  = "-1"
      referenced_security_group_id = module.db_security_group.id
      description                  = "All traffic from DB servers"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic for downloads and updates"
    }
    to_db_servers = {
      ip_protocol                  = "-1"
      referenced_security_group_id = module.db_security_group.id
      description                  = "All traffic to DB servers"
    }
  }

  tags = {
    Terraform   = "true"
  }
}