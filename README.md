# iac-terraform-aws

Infrastructure as Code (IaC) project using Terraform to provision AWS resources.

## What it does
- Creates an S3 bucket
- Enables bucket versioning
- Applies a public access block (secure-by-default)
- Adds consistent resource tags

## Requirements
- Terraform >= 1.5
- AWS CLI configured (`aws configure`)
- An AWS account with permissions to manage S3

## Usage

Create a `terraform.tfvars` file:

```hcl
bucket_name = "your-globally-unique-bucket-name"
```

```bash
terraform init
terraform plan
terraform apply
```

## Notes
terraform.tfvars is intentionally not committed.
Use terraform.tfvars.example as a template.
