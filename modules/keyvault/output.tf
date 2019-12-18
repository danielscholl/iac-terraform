##############################################################
# This module allows the creation of a Key Vault
##############################################################

# The dependency of these values on the keyvault access policy is required in
# order to create an explicit dependency between the access policy that
# allows the service principal executing the deployment and the keyvault
# ID. This ensures that the access policy is always configured prior to
# managing entitites within the keyvault.
#
# More documentation on this stanza can be found here:
#   https://www.terraform.io/docs/configuration/outputs.html#depends_on-explicit-output-dependencies

output "name" {
  description = "The name of the Keyvault"
  value       = azurerm_key_vault.main.name
  depends_on = [
    module.deployment_service_principal_keyvault_access_policies
  ]
}

output "id" {
  description = "The id of the Keyvault"
  value       = azurerm_key_vault.main.id
  depends_on = [
    module.deployment_service_principal_keyvault_access_policies
  ]
}

output "uri" {
  description = "The uri of the keyvault"
  value       = azurerm_key_vault.main.vault_uri
  depends_on = [
    module.deployment_service_principal_keyvault_access_policies
  ]
}

output "secrets" {
  value       = { for k, v in azurerm_key_vault_secret.main : v.name => v.id }
  description = "A mapping of secret names and URIs."
}

output "references" {
  value = {
    for k, v in azurerm_key_vault_secret.main :
    v.name => format("@Microsoft.KeyVault(SecretUri=%s)", v.id)
  }
  description = "A mapping of Key Vault references for App Service and Azure Functions."
}
