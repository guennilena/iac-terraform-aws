
// bootstrap/variables.tf_lock

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = "default"
}

variable "project" {
  type        = string
  description = "Project tag value"
  default     = "terraform-associate-004"
}

variable "state_bucket_prefix" {
  type        = string
  description = "Prefix for the Terraform remote state bucket name (suffix is added automatically)"
  default     = "tfstate-blacky"
}

variable "lock_table_prefix" {
  type        = string
  description = "Prefix for the DynamoDB state lock table name (suffix is added automatically)"
  default     = "terraform-state-lock"
}