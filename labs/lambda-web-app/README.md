# Lambda Web App (Terraform)

Serverless web app lab on AWS provisioned with Terraform.

## Architecture

Frontend:
- S3 bucket (private)
- CloudFront distribution (HTTPS, CDN)
- CloudFront Origin Access Control (OAC) for private S3 access

Backend:
- API Gateway (HTTP API)
- AWS Lambda (Python 3.11)
- CloudWatch Logs

Request flow:
- Browser → CloudFront → S3 (static assets)
- Browser → CloudFront `/api/*` → API Gateway → Lambda (JSON)

## Repository Structure

```text
lambda-web-app/
├── app/                 # Lambda backend (Python)
├── frontend/            # Static frontend (HTML/JS)
└── terraform/           # Terraform configuration
```

## Prerequisites

Terraform >= 1.5

AWS CLI configured

AWS profile set via environment variable (e.g. AWS_PROFILE=terraform)

## Deploy

```bash
cd terraform
terraform init
terraform apply
```

## Test

Frontend (CloudFront):

Open frontend_url output in the browser

Backend (direct, optional):

Use api_base_url output

Caching / Updates

index.html is configured with Cache-Control: no-cache for fast iteration.

If CloudFront still serves stale content, invalidate:

```bash
aws cloudfront create-invalidation \
  --distribution-id "<DIST_ID>" \
  --paths "/" "/index.html" "/app.js"
```

## Cost Control

- AWS Budget enabled
- Default tags via Terraform provider
