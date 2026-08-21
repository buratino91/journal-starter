module "ec2_security_group" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "ec2-SG"
    description = "Security group for EC2 instance (SSM)"
    vpc_id      = var.vpc_id

    egress_rules = {
       rds = {
            from_port       = 5432
            to_port         = 5432
            protocol        = "tcp"
            cidr_ipv4       = "0.0.0.0/0"
            description     = "Allow PostgreSQL to RDS"
       }
        https_to_endpoints = {
            from_port       = 443
            to_port         = 443
            protocol        = "tcp"
            cidr_ipv4       = "0.0.0.0/0" 
            description     = "Allow HTTPS to VPC endpoints"
  }
    }
}