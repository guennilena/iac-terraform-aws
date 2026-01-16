provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "lambda-web-app"
      Lab     = "serverless"
      Owner   = "terraform"
      Managed = "terraform"
    }
  }
}
