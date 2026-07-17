output "ecr_read_write_role_arn" {
  value = aws_iam_role.ecr_read_write.arn
}

output "api_server_security_group_id" {
  value = module.security_group.id
}