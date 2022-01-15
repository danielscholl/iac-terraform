##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################

output "id" {
  description = "The Log Analytics Workspace Id"
  value       = azurerm_log_analytics_workspace.main.id
}

output "name" {
  description = "The Log Analytics Workspace Name"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_workspace_id" {
  value = azurerm_log_analytics_workspace.main.workspace_id
}

output "log_workspace_key" {
  value = azurerm_log_analytics_workspace.main.primary_shared_key
}