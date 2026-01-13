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

Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

```md
## Remote state

### Backend configuration (HCL)
```

Terraform uses an S3 backend with DynamoDB state locking:

```hcl
backend "s3" {
  bucket         = "iac-terraform-aws-dev-state-20260113-0731"
  key            = "iac-terraform-aws/dev/terraform.tfstate"
  region         = "eu-central-1"
  dynamodb_table = "terraform-state-lock"
  encrypt        = true
}
```

```md
## IAM

### Least-privilege IAM policy (JSON)
```

A custom IAM policy is used for the Terraform user.  
See `docs/iam-policy.json` for the full policy definition.

## Notes
terraform.tfvars is intentionally not committed.
Use terraform.tfvars.example as a template.
