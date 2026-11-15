#resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-compute"
  location = var.location
  tags     = local.common_tags
}

#Vnet

resource "azurerm_virtual_network" "vnet" {

  name                = "vnet-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = [var.vnet_cidr]
  tags          = local.common_tags
}

#VM subnet
resource "azurerm_subnet" "vm_subnet" {

  name                 = "snet-${var.environment}-vm"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [var.vm_subnet_cidr]
}

#bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet" #mandatorily named this
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [var.bastion_subnet_cidr]
}

#NSG

resource "azurerm_network_security_group" "nsg" {

  name                = "nsg-${var.environment}-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name      = "Allow-SSH-From-Bastion"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "22"

    source_address_prefix      = var.bastion_subnet_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

#Associate NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "vm_nsg_assoc" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#Bastion public IP
resource "azurerm_public_ip" "bastion_pip" {

  name                = "pip-${var.environment}-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.common_tags
}

#bastion host
resource "azurerm_bastion_host" "bastion" {

  name                = "bastion-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku         = "Standard"
  scale_units = 2

  copy_paste_enabled = true
  tunneling_enabled  = true

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = local.common_tags
}

#NIC for VMs
resource "azurerm_network_interface" "nic" {

  count = var.vm_count

  name = "nic-${var.environment}-${format("%02d", count.index + 1)}"

  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

#Linux VMs
resource "azurerm_linux_virtual_machine" "vm" {

  count         = var.vm_count
  name          = "vm-${var.environment}-${format("%02d", count.index + 1)}"
  computer_name = "vm-${var.environment}-${format("%02d", count.index + 1)}"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  disable_password_authentication = true

  # SSH authentication

  admin_ssh_key {

    username   = var.admin_username
    public_key = var.ssh_public_key
  }


  # OS disk

  os_disk {

    name                 = "osdisk-${var.environment}-${format("%02d", count.index + 1)}"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }


  # Ubuntu 22.04 image

  source_image_reference {

    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


  # System-assigned managed identity

  identity {

    type = "SystemAssigned"
  }


  boot_diagnostics {}
  tags = local.common_tags
}

locals {
  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}



