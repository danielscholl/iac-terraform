##############################################################
# This module allows the creation of a service-principal
##############################################################

output "id" {
  description = "The ID of the Azure AD Service Principal"
  value       = var.create_for_rbac == true ? azuread_service_principal.main[0].object_id : var.object_id
}

output "name" {
  description = "The Display Name of the Azure AD Application associated with this Service Principal"
  value       = var.create_for_rbac == true ? azuread_service_principal.main[0].display_name : var.principal.name
}

output "client_id" {
  description = "The ID of the Azure AD Application"
  value       = var.create_for_rbac == true ? azuread_service_principal.main[0].application_id : var.principal.appId
}

output "client_secret" {
  description = "The password of the generated service principal. This is only exported when create_for_rbac is true."
  value       = var.create_for_rbac == true ? azuread_service_principal_password.main[0].value : var.principal.password
  sensitive   = true
}
