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
  password_wo = var.POSTGRES_PASSWORD # from terraform.tfvars
  username    = "postgres"
  port        = 5432

  family                 = "postgres17"
  create_db_subnet_group = true
  subnet_ids             = var.db_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
}

resource "null_resource" "init_db" {
  depends_on = [module.rds]

  triggers = {
    instance_id = module.rds.db_instance_resource_id
  }

  provisioner "local-exec" {
    command = <<EOT
      PGPASSWORD=${var.POSTGRES_PASSWORD}
      psql -h ${module.rds.db_instance_address} -p ${module.rds.db_instance_port} -U postgres -d ${var.POSTGRES_DB}  -f ../../database_setup.sql
    EOT
  }
}