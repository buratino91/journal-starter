module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "journal-api-eks"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id                 = var.vpc_id # from VPC module - have to declare as a var to access it here
  subnet_ids             = var.public_subnet_ids
  node_security_group_id = var.node_security_group_id

  create_iam_role = true

  tags = {
    Terraform = "true"
  }
}