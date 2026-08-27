variable "db_subnet" {
  description = "The private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID for the RDS instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group ID to be associated to the database"
  type        = list(string)
}

variable "POSTGRES_DB" {
  description = "Name of database server"
  type        = string
}

variable "POSTGRES_USER" {
  description = "Username for the database server"
  type        = string
}