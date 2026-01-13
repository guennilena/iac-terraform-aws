resource "aws_s3_bucket" "example" {
  bucket = "blacky-terraform-150524"

  tags = {
    Name        = "terraform-basics"
    Environment = "learning"
  }
}
