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