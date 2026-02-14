variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix for all resources"
  default     = "lab-azure-vm"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_B1s"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to your SSH public key (e.g., ~/.ssh/id_rsa.pub)"
  default     = "~/.ssh/id_ed25519.pub"
}
