# iac-terraform-aws

Infrastructure as Code (IaC) examples using Terraform on AWS.

This repository contains:
- a **bootstrap** stack to create a secure remote Terraform state backend (S3 + DynamoDB locking)
- multiple **labs** (EC2/SSM, RDS, Lambda web app) used during training

> Note: The labs are intentionally lightweight and may use **local state** unless a backend is configured.

---

## Repository structure

- **Root/` (this directory)**
  Legacy S3 bucket example (initial project)”

- `bootstrap/`  
  Creates the remote state backend:
  - S3 bucket (versioning + encryption + public access block)
  - DynamoDB table for state locking

- `labs/`  
  Independent Terraform configurations used as practice labs (each lab has its own working directory/state).
  - `ec2-ssm/` – AWS: EC2 managed via SSM Session Manager (no inbound SSH)
  - `azure-vm-runcommand/` – Azure: Linux VM managed via Run Command/Serial Console (no inbound SSH), comparable to `ec2-ssm`

---

## Requirements

- Terraform >= 1.5
- AWS CLI installed and configured
- AWS account permissions for the resources you plan to create (S3/DynamoDB for bootstrap, plus the lab-specific services)

---

## AWS credentials

Terraform reads credentials from the standard AWS credential chain.

Recommended: configure a named AWS CLI profile:

```bash
aws configure --profile terraform
aws sts get-caller-identity --profile terraform
```

Optional (macOS / Linux):

```bash
export AWS_PROFILE=terraform
export AWS_REGION=eu-central-1
```

## Quickstart: bootstrap remote state (recommended first)

Copy bootstrap/terraform.tfvars.example to bootstrap/terraform.tfvars and adjust values.

Run this once to create the remote state backend.

```bash
cd bootstrap
terraform init -backend=false
terraform apply
```

After apply, Terraform prints outputs similar to:
- state_bucket_name (e.g. tfstate-...-<suffix>)
- lock_table_name (e.g. terraform-state-lock-<suffix>)

Use these values when configuring an S3 backend for other stacks.

## IAM

This repo uses IAM in two places:

1) **Per-lab IAM (Terraform-managed)**
   Some labs define their own IAM roles/policies in `iam.tf` (e.g. Lambda execution role, EC2 instance role).

2) **Terraform operator permissions (example policy)**
   An example IAM policy for the identity running Terraform (state backend access) is provided:
   - `docs/iam-policy.json`

   Note: This file is an example/template and must be adapted to your bucket/table naming. Lab stacks typically require additional permissions.

## Working with labs

Each lab is an independent Terraform working directory.
Run commands in the directory that contains the .tf files.

Examples:

```bash
cd labs/ec2-ssm
terraform init
terraform plan
terraform apply
terraform destroy
```

```bash
cd labs/rds-database/terraform
terraform init
terraform plan
terraform apply
terraform destroy
```

## About Terraform state

Terraform state is maintained per working directory:
- without a backend block: local state (terraform.tfstate) in that directory
- with an S3 backend: state stored remotely in S3, optionally locked via DynamoDB

## Notes

- Keep AWS credentials out of .tf files and out of version control.
- Costs: most labs should be destroyed after use. Pay special attention to RDS, NAT Gateway, and any long-running compute resources.

