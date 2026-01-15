# iac-terraform-aws

Infrastructure as Code (IaC) project using Terraform to provision AWS resources on AWS.

## What it does
- Creates an S3 bucket
- Enables bucket versioning
- Applies a public access block (secure-by-default)
- Adds consistent resource tags
- Uses a remote Terraform state stored in S3

## Requirements
- Terraform >= 1.5
- AWS CLI configured
- An AWS account with permissions to manage S3

## AWS Credentials

This project uses a named AWS CLI profile.

Required profile:
- Profile name: `terraform`

Configure credentials using the AWS CLI:

```bash
aws configure --profile terraform

Or set the profile explicitly before running Terraform:

# Windows (PowerShell)
$env:AWS_PROFILE="terraform"

# Windows (cmd)
set AWS_PROFILE=terraform

# Linux / macOS
export AWS_PROFILE=terraform
```

## Usage

Create a terraform.tfvars file:
```hcl
bucket_name = "your-globally-unique-bucket-name"
```

Initialize and apply the Terraform configuration:
```bash
terraform init
terraform plan
terraform apply
```

If backend configuration changes, reinitialize Terraform:
```bash
terraform -reconfigure
```

## Remote State

Terraform uses a remote S3 backend to store the state file.
State locking is handled using the S3-native lock file mechanism.

## Backend configuration (HCL)
```hcl
backend "s3" {
  bucket       = "iac-terraform-aws-dev-state-20260113-0731"
  key          = "iac-terraform-aws/dev/terraform.tfstate"
  region       = "eu-central-1"
  encrypt      = true
  use_lockfile = true
}
```

## IAM
A custom least-privilege IAM policy is used for the Terraform user.
See docs/iam-policy.json for the full policy definition.

## Architecture
```text
+----------------------+
|  Terraform CLI       |
|  (local machine)     |
+----------+-----------+
           |
           | AWS API calls
           v
+----------------------+
|  AWS Account         |
|                      |
|  +----------------+  |
|  | S3 State       |  |
|  | Bucket         |  |
|  | (versioned)    |  |
|  +----------------+  |
|          |           |
|          v           |
|  +----------------+  |
|  | Lock File      |  |
|  | (S3-native)   |  |
|  +----------------+  |
|                      |
|  +----------------+  |
|  | Project S3     |  |
|  | Bucket         |  |
|  +----------------+  |
+----------------------+
```

## Notes

terraform.tfvars is intentionally not committed.
Use terraform.tfvars.example as a template.

