output "instance_id" {
  value = aws_instance.this.id
}

output "region" {
  value = var.aws_region
}

output "role_name" {
  value = aws_iam_role.ec2.name
}

output "lab_bucket_name" {
  value = aws_s3_bucket.lab.bucket
}
