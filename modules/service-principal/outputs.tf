##############################################################
# This module allows the creation of a service-principal
##############################################################

output "id" {
  description = "The ID of the Azure AD Service Principal"
  value       = azuread_service_principal.main[0].object_id
}

output "client_id" {
  description = "The ID of the Azure AD Application"
  value       = azuread_service_principal.main[0].application_id
}

output "name" {
  description = "The Display Name of the Azure AD Application associated with this Service Principal"
  value       = azuread_service_principal.main[0].display_name
}

output "client_secret" {
  description = "The password of the generated service principal. This is only exported when create_for_rbac is true."
  value       = azuread_service_principal_password.main[0].value
  sensitive   = true
}
