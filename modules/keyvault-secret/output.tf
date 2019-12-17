##############################################################
# This module allows the creation of a Key Vault Secret
##############################################################

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
