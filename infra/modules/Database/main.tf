module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "l2c-db"
  instance_class = "db.t3.micro"
  engine                   = "postgres"
  engine_version           = "17"

  db_name  = var.POSTGRES_DB # from terraform.tfvars
  password = var.POSTGRES_PASSWORD # from terraform.tfvars
  username = "postgres"
  port     = 5432
  
  db_subnet_group_name = var.db_subnet
  vpc_security_group_ids = var.db_security_group_id
}

resource "null_resource" "init_db" {
  depends_on = [module.rds]

  triggers = {
    instance_id = module.rds.db_instance_resource_id
  }

  provisioner "local-exec" {
    command = <<EOT
      PGPASSWORD=${var.POSTGRES_PASSWORD}
      psql -h ${module.rds.db_instance_endpoint} -U postgres -d ${var.POSTGRES_DB}  -f ../../database_setup.sql
    EOT
  }
}