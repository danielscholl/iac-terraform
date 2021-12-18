##############################################################
# This module allows the creation of a Resource Group
##############################################################

output "name" {
  description = "The name of the Resource Group."
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The location of the Resource Group."
  value       = azurerm_resource_group.main.location
}

output "id" {
  description = "The id of the Resource Group."
  value       = azurerm_resource_group.main.id
}

output "random" {
  description = "A random string derived from the Resource Group."
  value       = random_id.main.hex
}
