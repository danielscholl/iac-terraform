##############################################################
# This module allows the creation of a Function App
##############################################################


output "uris" {
  description = "The URLs of the function apps created"
  value       = azurerm_function_app.main.*.default_hostname
}

output "ids" {
  description = "The resource ids of the function apps created"
  value       = azurerm_function_app.main.*.id
}

output "names" {
  description = "The names of the function apps created"
  value = [
    for name in keys(var.function_app_config) :
    "${var.name}-${lower(name)}"
  ]
}

output "identity_tenant_id" {
  description = "The Tenant ID for the Service Principal associated with the Managed Service Identity of this Function App."
  value       = azurerm_function_app.main[0].identity[0].tenant_id
}

output "identity_object_ids" {
  description = "The Principal IDs for the Service Principal associated with the Managed Service Identity for all Function Apps."
  value       = azurerm_function_app.main.*.identity.0.principal_id
}
