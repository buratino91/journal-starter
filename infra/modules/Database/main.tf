module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "l2c-db"
  instance_class = "db.t3.micro"
  engine                   = "postgres"
  engine_version           = "17"

  db_name  = "career_journal"
  username = "postgres"
  port     = 5432
  
  db_subnet_group_name = var.db_subnet
  vpc_security_group_ids = var.db_security_group_id
}
# TODO:
# Use null resource and provisioner "local=exec" to run the SQL script to create the database and tables after the RDS instance is created.