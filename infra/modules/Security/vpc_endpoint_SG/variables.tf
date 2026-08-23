variable "referenced_security_group_id" {
    description = "ID of security group to reference to for SSM"
    type = string
}

variable "vpc_id" {
    description = "ID of VPC to be associated to"
    type = string
}