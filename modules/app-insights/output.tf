##############################################################
# This module allows the creation of Application Insights
##############################################################

output "id" {
  description = "The Application Insights Id"
  value       = azurerm_application_insights.main.app_id
}

output "instrumentation_key" {
  description = "The Application Insights Instrumentation Key."
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "name" {
  description = "The name of the appinsights resource"
  value       = azurerm_application_insights.main.name
}
