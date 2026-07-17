module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.16.0.0/24"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.16.0.32/28", "10.16.0.80/28", "10.16.0.128/28"] 
  public_subnets  = ["10.16.0.16/28", "10.16.0.64/28", "10.16.0.112/28"] # an IGW will be created by default since public_subnets is not empty

  enable_nat_gateway = true # default: one per public subnet
  enable_dns_hostnames = true

  tags = {
        name = "journal-api-vpc"
    }

  
}