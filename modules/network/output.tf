##############################################################
# This module allows the creation of a Virtual Network
##############################################################

output "id" {
  description = "The virtual network Id"
  value       = azurerm_virtual_network.main.id
}

output "name" {
  description = "The virtual network name"
  value       = azurerm_virtual_network.main.name
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = azurerm_virtual_network.main.address_space
}

output "subnets" {
  description = "The ids of subnets created inside the virtual network."
  value       = azurerm_subnet.main.*.id
}