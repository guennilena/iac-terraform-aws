variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique name for the Terraform remote state bucket"
}

variable "lock_table_name" {
  type        = string
  description = "Name of the DynamoDB table used for state locking"
  default     = "terraform-state-lock"
}
