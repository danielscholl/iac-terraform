output "name" {
  value       = azuread_service_principal.main.display_name
  description = "The Service Principal Display Name."
}

output "object_id" {
  value       = azuread_service_principal.main.id
  description = "The Service Principal Object Id."
}

output "tenant_id" {
  value = data.azurerm_client_config.main.tenant_id
  description = "The Service Principal Tenant Id."
}

output "client_id" {
  value       = azuread_application.main.application_id
  description = "The Service Principal Client Id (Application Id)"
}

output "client_secret" {
  value       = azuread_service_principal_password.main[0].value
  sensitive   = true
  description = "The Service Principal Client Secret (Application Password)."
}