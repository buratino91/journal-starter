output "db_security_group_id" {
  value = module.db_security_group.id
}

output "db_instance_resource_id" {
  value = module.rds.db_instance_resource_id
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}