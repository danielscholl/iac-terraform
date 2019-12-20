##############################################################
# This module allows the creation of an Application Gateway
##############################################################

output "name" {
  description = "The name of the Application Gateway created"
  value       = azurerm_application_gateway.main.name
}

output "ipconfig" {
  description = "The Application Gateway IP Configuration"
  value       = azurerm_application_gateway.main.gateway_ip_configuration
}

output "frontend_ip_configuration" {
  description = "The Application Gateway Frontend IP Configuration"
  value       = azurerm_application_gateway.main.frontend_ip_configuration
}

output "health_probe_backend_status" {
  value = data.external.app_gw_health.result["health"]
}

output "health_probe_backend_address" {
  value = data.external.app_gw_health.result["address"]
}