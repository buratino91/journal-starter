module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "journal-api-eks"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  node_security_group_id = module.api_server_security_group.id
  
  create_iam_role = false
  iam_role_arn = module.api_server_security_group.security_group_arn


  tags = {
    Terraform   = "true"
  }
}