
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "bastion_name" {
  value = azurerm_bastion_host.bastion.name
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}

output "vm_names" {
  value = azurerm_linux_virtual_machine.vm[*].name
}

output "vm_ids" {
  value = azurerm_linux_virtual_machine.vm[*].id
}

output "vm_private_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}
