variable "vpc_id" {
    description = "The ID of the VPC where the database will be deployed"
    type        = string
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs for the database"
    type        = list(string)
}

variable "db_security_group_id" {
    description = "The ID of the security group for the database"
    type        = string
}