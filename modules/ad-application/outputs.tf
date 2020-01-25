##############################################################
# This module allows the creation of an Active Directory App
##############################################################

output "config_data" {
  description = "Output data that pairs azuread names with their application ids."
  value = {
    for azuread in data.azuread_application.main :
    azuread.name => {
      application_id = azuread.application_id
    }
  }
}

output "app_ids" {
  description = "Output data that pairs azuread names with their application ids."
  value       = data.azuread_application.main.*.application_id
}
