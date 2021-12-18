##############################################################
# This module allows the creation of a AD Application
##############################################################

output "name" {
  value       = azuread_application.main.display_name
  description = "The display name of the application."
}

output "id" {
  value       = azuread_application.main.application_id
  description = "The ID of the application."
}

output "object_id" {
  value       = azuread_application.main.object_id
  description = "The object ID of the application."
}

output "roles" {
  value = {
    for r in azuread_application.main.app_role :
    r.display_name => {
      id          = r.id
      name        = r.display_name
      value       = r.value
      description = r.description
      enabled     = r.enabled
    }
  }
  description = "The application roles."
}

output "password" {
  value       = azuread_application_password.main.0.value
  sensitive   = true
  description = "The password for the application."
}
