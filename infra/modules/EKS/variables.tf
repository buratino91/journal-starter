variable "vpc_id" {
  description = "The ID of the VPC where the nodes will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the nodes"
  type        = list(string)
}

variable "node_security_group_id" {
  description = "ID of security group to be attached to the nodes"
  type        = string
}