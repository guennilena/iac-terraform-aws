output "bucket_name" {
  value       = aws_s3_bucket.example.bucket
  description = "Name of the created S3 bucket"
}
