##############################################################
# This module allows the creation of API Management Service
##############################################################

output "id" {
  description = "The ID of the API Management Service created"
  value       = azurerm_api_management.main.id
}

output "url" {
  description = "The URL of the Gateway for the API Management Service"
  value       = azurerm_api_management.main.gateway_url
}

output "public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service"
  value       = azurerm_api_management.main.public_ip_addresses
}

output "identity_tenant_id" {
  description = "The Tenant ID for the Service Principal associated with the Managed Service Identity of this API Management Service"
  value       = azurerm_api_management.main.identity[0].tenant_id
}

output "identity_object_id" {
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity for the API Management Service"
  value       = azurerm_api_management.main.identity[0].principal_id
}