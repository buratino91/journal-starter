variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# These variables will be passed in via tfvars file
variable "my_ip" {
  description = "My IP address to allow SSH into the DB server"
  type = string
}

variable "POSTGRES_DB" {
  description = "Name of DB server"
  type = string
}

variable "POSTGRES_PASSWORD" {
  description = "Master password of DB server"
  type = string
  sensitive = true
}