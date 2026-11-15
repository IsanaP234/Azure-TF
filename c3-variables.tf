variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# variable "resource_group_name" {
#   description = "Environment resource group"
#   type        = string
# }

variable "location" {
  description = "Azure deployment region"
  type        = string
  default     = "eastus2"
}

variable "vnet_cidr" {
  description = "VNet address range"
  type        = string
}

variable "vm_subnet_cidr" {
  description = "VM subnet address range"
  type        = string
}

variable "bastion_subnet_cidr" {
  description = "Dedicated Bastion subnet address range"
  type        = string
}

variable "vm_count" {
  description = "Number of Linux VMs"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
}

variable "admin_username" {
  description = "Linux administrator username"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for Linux VM authentication"
  type        = string
}

variable "os_disk_size_gb" {
  description = "OS disk size"
  type        = number
}

variable "os_disk_type" {
  description = "OS disk storage type"
  type        = string
}
