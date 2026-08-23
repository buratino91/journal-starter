module "endpoint_security_group" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "endpoint-SG"
    description = "Security group for VPC endpoints"
    vpc_id      = var.vpc_id

    egress_rules = {
        all = {
            ip_protocol = "-1"
            cidr_ipv4 = "0.0.0.0/0"
            description = "allow all outbound traffic"
        }
    }

    ingress_rules = {
    https_from_ec2 = {
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        referenced_security_group_id = var.referenced_security_group_id
        description              = "Allow HTTPS from EC2 for SSM"
    }
    }
}