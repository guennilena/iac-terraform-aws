output "api_base_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_regional_domain" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_url" {
  value = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}
