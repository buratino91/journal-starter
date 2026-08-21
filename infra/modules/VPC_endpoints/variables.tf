variable "vpc_id" {
    description = "ID of VPC"
    type = string
}

variable "security_group_ids" {
    description = "Security group that will be attached to the VPC endpoints"
    type = list(string)
}