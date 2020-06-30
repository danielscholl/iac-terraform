##############################################################
# This module allows the creation of a Container Registry
##############################################################

output "id" {
  description = "The Container Registry ID."
  value       = azurerm_container_registry.main.id
}

output "name" {
  description = "The name of the azure container registry resource"
  value       = var.name
}

output "url" {
  description = "The URL that can be used to log into the container registry."
  value       = azurerm_container_registry.main.login_server
}

output "admin_username" {
  description = "If admin access is enabled, this will be the username for the ACR"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "If admin access is enabled, this will be the password for the ACR"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}