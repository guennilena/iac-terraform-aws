# RDS PostgreSQL (Terraform Lab)

This lab demonstrates how to create an Amazon RDS PostgreSQL database using Terraform.

## Architecture

- Dedicated VPC (Single Region)
- Two private subnets in different AZs (required for RDS subnet groups)
- RDS PostgreSQL instance (Single-AZ)
- No public access
- Security Group allowing PostgreSQL access only from within the VPC

## Key Characteristics

- Engine: PostgreSQL
- Instance class: db.t4g.micro (Free Tier eligible)
- Deployment: Single-AZ
- Public access: disabled
- Backup retention: minimal (lab setup)
- Deletion protection: disabled
- Final snapshot: skipped

## Purpose

- Fulfill the AWS exam objective: **Create an Aurora or RDS database**
- Understand:
  - RDS subnet group requirements
  - Difference between Single-AZ and Multi-AZ
  - Regional nature of RDS
  - Cost-aware database provisioning

## Deploy

```bash
terraform init
terraform apply
```

## Cleanup
```bash
terraform destroy
```


