##############################################################
# This module allows the creation of an Active Directory App
##############################################################

output "name" {
  description = "The name of the application."
  value = azuread_application.main.name
}

output "app_id" {
  description = "The id of the application."
  value = azuread_application.main.application_id
}
