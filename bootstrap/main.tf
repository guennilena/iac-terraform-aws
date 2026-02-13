// bootstrap/main.tf

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  state_bucket_name = lower("${var.state_bucket_prefix}-${random_id.suffix.hex}")
  lock_table_name   = lower("${var.lock_table_prefix}-${random_id.suffix.hex}")

  tags = {
    ManagedBy = "Terraform"
    Project   = var.project
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket = local.state_bucket_name

  tags = merge(local.tags, {
    Name = "terraform-remote-state"
  })
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = local.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(local.tags, {
    Name = "terraform-state-lock"
  })
}
