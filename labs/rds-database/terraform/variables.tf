variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "project_name" {
  type    = string
  default = "rds-postgres"
}

variable "vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.30.1.0/24"
}

variable "private_subnet_cidr_b" {
  type    = string
  default = "10.30.2.0/24"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

# Setze das als TF_VAR_db_password in der Shell oder in terraform.tfvars (nicht ins Git)
variable "db_password" {
  type      = string
  sensitive = true
}
