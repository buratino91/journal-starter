module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "l2c/journal-app"

  repository_read_write_access_arns = var.ecr_read_write_role_arn # from Security module
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
  }
}