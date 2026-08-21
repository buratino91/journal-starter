variable "subnet_id" {
    description = "The subnet ID to launch the EC2 in"
    type = string
}

variable "vpc_security_group_ids" {
    description = "SG to attach to EC2 instance"
    type = list(string)
}   