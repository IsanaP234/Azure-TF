
environment = "preprod"
location    = "eastus"

vnet_cidr           = "10.20.0.0/16"
vm_subnet_cidr      = "10.20.1.0/24"
bastion_subnet_cidr = "10.20.2.0/26"

vm_count = 1

#vm_size = "Standard_D2s_v5"
vm_size        = "Standard_D2s_v7"
admin_username = "azureadmin"

os_disk_size_gb = 64
os_disk_type    = "StandardSSD_LRS"

