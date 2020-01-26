output "id" {
  description = "The Container Registry ID."
  value       = azurerm_container_registry.container_registry.id
}

output "name" {
  description = "The name of the azure container registry resource"
  value       = var.container_registry_name
}

output "url" {
  description = "The URL that can be used to log into the container registry."
  value       = azurerm_container_registry.container_registry.login_server
}

output "admin_username" {
  description = "If admin access is enabled, this will be the username for the ACR"
  value       = azurerm_container_registry.container_registry.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "If admin access is enabled, this will be the password for the ACR"
  value       = azurerm_container_registry.container_registry.admin_password
  sensitive   = true
}