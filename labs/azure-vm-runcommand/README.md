# Azure VM (Run Command) – AWS EC2/SSM comparison lab

This lab mirrors the idea of the AWS `ec2-ssm` lab: a small VM with **no inbound SSH** and management via Azure platform features.

## What it creates
- Resource Group
- VNet/Subnet
- NSG with **no inbound allow rules** (default inbound is deny unless explicitly opened)
- Linux VM + NIC
- Optional Public IP (for visibility only)

## Prerequisites
- Azure CLI login:
  ```bash
  az login
  az account show
  ```
- Terraform installed

## SSH key requirement (important)

Azure requires an RSA public key for azurerm_linux_virtual_machine in this lab.

Create a dedicated RSA keypair:

```bash
ssh-keygen -t rsa -b 4096 -C "terraform-azure" -f ~/.ssh/id_rsa_azure
```

Create terraform.tfvars (not committed):

```bash
ssh_public_key_path = "~/.ssh/id_rsa_azure.pub"
location            = "northeurope"
vm_size             = "Standard_D2as_v7"
```

## Usage

```bash
cd terraform
terraform init
terraform plan
terraform apply
terraform destroy
```
## No-inbound management (SSM-style comparison)

### Azure Run Command (non-interactive)

Azure Portal → VM → Operations → Run command → RunShellScript

Run Command executes a script and returns the output (not an interactive shell).

Good demo commands:

```bash
whoami && hostname && uname -a
```

```bash
ip a && echo "---" && ip route
```

> Note: ifconfig is not installed by default on modern Ubuntu images. Prefer ip a.

## Notes

- Azure NSGs include default inbound rules such as AllowAzureLoadBalancerInBound and DenyAllInBound.
There is still no inbound SSH unless you add an explicit allow rule.
- Keep credentials out of Terraform code and out of version control.
- Destroy resources after testing to avoid unnecessary cost.
