
environment         = "prod"
location = "eastus2"

vnet_cidr           = "10.30.0.0/16"
vm_subnet_cidr      = "10.30.1.0/24"
bastion_subnet_cidr = "10.30.2.0/26"

vm_count = 3

vm_size = "Standard_D4s_v5"

admin_username = "azureadmin"

os_disk_size_gb = 128
os_disk_type    = "Premium_LRS"