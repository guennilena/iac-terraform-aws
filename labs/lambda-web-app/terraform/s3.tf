############################################
# S3 bucket for static frontend (private)
############################################

resource "random_string" "s3_suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  # S3 bucket names must be globally unique and lowercase
  frontend_bucket_name = lower("${var.project_name}-frontend-${random_string.s3_suffix.result}")
}

resource "aws_s3_bucket" "frontend" {
  bucket = local.frontend_bucket_name
}

# Recommended ownership setting (avoids ACL-related surprises)
resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Keep the bucket private (CloudFront will access it later via OAC)
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional but typically useful for labs
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

############################################
# Upload frontend files (from ../frontend)
############################################

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  content_type = "text/html"
  cache_control = "no-cache, no-store, must-revalidate"

  etag = filemd5("${path.module}/../frontend/index.html")

  depends_on = [aws_s3_bucket_ownership_controls.frontend]
}

resource "aws_s3_object" "app_js" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "app.js"
  source       = "${path.module}/../frontend/app.js"
  content_type = "application/javascript"

  etag = filemd5("${path.module}/../frontend/app.js")

  depends_on = [aws_s3_bucket_ownership_controls.frontend]
}
