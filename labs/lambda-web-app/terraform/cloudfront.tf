############################################
# CloudFront in front of private S3 (OAC)
############################################

resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "${var.project_name}-frontend-oac"
  description                       = "OAC for ${var.project_name} frontend bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  comment             = "${var.project_name} frontend"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "s3-frontend"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  origin {
    domain_name = replace(aws_apigatewayv2_api.http_api.api_endpoint, "https://", "")
    origin_id   = "apigw-http-api"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-frontend"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "apigw-http-api"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    compress = true

    forwarded_values {
      query_string = true

      headers = [
        "Authorization",
        "Origin",
        "Access-Control-Request-Method",
        "Access-Control-Request-Headers"
      ]

      cookies {
        forward = "all"
      }
    }

    # Falls du Security Headers Policy nutzt, auch hier anhängen:
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

############################################
# Allow CloudFront to read from the bucket
############################################

data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.frontend.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
}


############################################
# s3.tf contains cache_control = "no-cache, no-store, must-revalidate"
# if cache is enabled use the follwing batch command
# aws cloudfront create-invalidation \
#  --distribution-id "$(terraform output -raw cloudfront_distribution_id)" \
#  --paths "/" "/index.html" "/app.js"
############################################
