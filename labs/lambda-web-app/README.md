# Lambda Web App (Terraform)

This lab demonstrates a serverless web application on AWS, fully provisioned with Terraform.

## Architecture (current state)

- AWS Lambda (Python 3.11)
- Amazon API Gateway (HTTP API)
- Amazon CloudWatch Logs
- Terraform for Infrastructure as Code

The Lambda function is exposed via an HTTP endpoint and returns JSON responses.

## Repository Structure

```text
lambda-web-app/
├── app/                 # Lambda backend (Python)
├── frontend/            # Static web app (planned)
└── terraform/           # Terraform configuration
```

## Cost Control

- AWS Budget enabled
- Default tags via Terraform provider
