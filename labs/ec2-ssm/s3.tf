# Zufälliger Suffix, damit der Bucket-Name global eindeutig ist
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "lab" {
  bucket        = "${var.name_prefix}-bucket-${random_id.bucket_suffix.hex}"
  force_destroy = true
  tags = {
    Name = "${var.name_prefix}-bucket"
  }
}

# Block Public Access (Best Practice)
resource "aws_s3_bucket_public_access_block" "lab" {
  bucket = aws_s3_bucket.lab.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Default Encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional, aber sinnvoll: Versioning (kannst du auch weglassen)
resource "aws_s3_bucket_versioning" "lab" {
  bucket = aws_s3_bucket.lab.id
  versioning_configuration {
    status = "Enabled"
  }
}
