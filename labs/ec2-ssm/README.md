# EC2 with IAM Role and SSM (Terraform Lab)

This lab demonstrates a **production-grade AWS authentication pattern** using
**IAM Roles** and **AWS Systems Manager Session Manager**, without any static
access keys on the EC2 instance.

The setup is intentionally minimal and cost-aware, while following AWS security
best practices.

---

## Goals

- Use **IAM Role instead of access keys** for EC2
- Access the instance via **SSM Session Manager** (no SSH, no open inbound ports)
- Demonstrate **temporary credentials via STS**
- Apply **least-privilege access** to a dedicated S3 bucket
- Manage everything via **Terraform (IaC)**

---

## Architecture Overview

- Amazon EC2 (Amazon Linux 2)
- IAM Role + Instance Profile
- AWS Systems Manager (SSM Agent + Session Manager)
- Dedicated S3 bucket with bucket-scoped permissions
- Minimal VPC with public subnet and Internet Gateway (no NAT)

Key principle:

> No long-lived credentials on the server.  
> Authentication is handled exclusively via IAM Role and STS.

---

## Authentication Model

- **Local machine**: AWS CLI profile (`terraform`) is used only to provision infrastructure
- **EC2 instance**: 
  - No `aws configure`
  - No access keys
  - Credentials are provided automatically via the EC2 metadata service
  - Rotated automatically by AWS (STS)

---

## Permissions

The EC2 IAM Role includes:
- `AmazonSSMManagedInstanceCore` (required for Session Manager)
- Custom IAM policy granting:
  - `s3:ListBucket` on one specific lab bucket
  - `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject` on objects within that bucket

Explicitly **not allowed**:
- `s3:ListAllMyBuckets`
- Any access outside the lab bucket

---

## Usage

### Deploy
```bash
terraform init
terraform apply
```

## Connect to EC2

AWS Console → EC2 → Instance → Connect → Session Manager

### Verify role-based authentication

```bash
aws sts get-caller-identity
aws configure list
```

### Test S3 access (bucket-scoped)

```bash
aws s3 ls s3://<lab-bucket-name>
```

## Cost Notes

This lab uses:

A single t3.micro EC2 instance

One small S3 bucket

No NAT Gateway

No load balancers or databases

Costs are minimal, especially when resources are destroyed after use.

## Cleanup

```bash
terraform destroy
```

Always destroy resources after testing to avoid unnecessary charges.

## Why This Matters

This setup reflects how AWS workloads are expected to run in production:

No hardcoded credentials

Automatic credential rotation

Strong separation between human access and workload access

Fully auditable, repeatable infrastructure via Terraform
