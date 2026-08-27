module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier     = "l2c-db"
  instance_class = "db.t3.micro"
  engine         = "postgres"
  engine_version = "17"
  allocated_storage = 5
  publicly_accessible = true

  db_name     = var.POSTGRES_DB       # from terraform.tfvars
  username    = var.POSTGRES_USER     # from terraform.tfvars
  port        = 5432

  family                 = "postgres17"
  create_db_subnet_group = true
  subnet_ids             = var.db_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
}