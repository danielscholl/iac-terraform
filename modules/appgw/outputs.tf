##############################################################
# This module allows the creation of an Application Gateway
##############################################################

output "name" {
  description = "The name of the Application Gateway created"
  value       = azurerm_application_gateway.main.name
}

output "id" {
  description = "The resource id of the Application Gateway created"
  value       = azurerm_application_gateway.main.id
}

output "ipconfig" {
  description = "The Application Gateway IP Configuration"
  value       = azurerm_application_gateway.main.gateway_ip_configuration
}

output "frontend_ip_configuration" {
  description = "The Application Gateway Frontend IP Configuration"
  value       = azurerm_application_gateway.main.frontend_ip_configuration
}

output "managed_identity_resource_id" {
  description = "The resource id of the managed user identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "managed_identity_principal_id" {
  description = "The resource id of the managed user identity"
  value       = azurerm_user_assigned_identity.main.principal_id
}
