provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = var.project_name
      Lab     = "rds-postgres"
      Managed = "terraform"
    }
  }
}
