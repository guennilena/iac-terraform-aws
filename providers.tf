provider "aws" {
  region  = var.aws_region
  profile = "terraform"
}

terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "iac-terraform-aws-dev-state-20260113-0731"
    key          = "iac-terraform-aws/dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
