variable "db_subnet" {
    description = "The subnet for the RDS instance"
    type = string
}

variable "db_security_group_id" {
    description = "The security group ID for the RDS instance"
    type = string
}

variable "vpc_id" {
    description = "The VPC ID for the RDS instance"
    type = string
}

variable "api_server_security_group_id" {
    description = "The security group ID for the EKS API server"
    type = string
}

variable "POSTGRES_DB" {
    description = "The name of the database to create"
    type = string
}

variable "POSTGRES_PASSWORD" {
    description = "The password for the PostgreSQL user"
    type = string
}

variable "my_ip" {
    description = "The IP address of the user for SSH access"
    type = string
}