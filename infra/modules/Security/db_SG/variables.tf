variable "api_server_security_group_id" {
  description = "ID of EKS security groups"
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

variable "my_ip" {
  description = "My IP address for SSH into DB server"
  type        = string
}

variable "ec2_security_group_id" {
  description = "ID of EC2 security group"
  type        = string
}

variable "endpoint_SG_id" {
  description = "ID of VPC endpoint security group"
  type        = string
}