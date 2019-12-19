##############################################################
# This module allows the creation of a Storage Account
##############################################################

output "id" {
  description = "The storage account Id."
  value       = azurerm_storage_account.main.id
}

output "name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the storage account."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.main.primary_connection_string
  description = "The primary connection string for the storage account."
}

output "primary_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
}

output "containers" {
  value = {
    for c in azurerm_storage_container.main :
    c.name => {
      id   = c.id
      name = c.name
    }
  }
  description = "Map of containers."
}

output "tenant_id" {
  description = "The tenant ID for the Service Principal of this storage account."
  value       = azurerm_storage_account.main.identity.0.tenant_id
}

output "managed_identities_id" {
  description = "The principal ID generated from enabling a Managed Identity with this storage account."
  value       = azurerm_storage_account.main.identity.0.principal_id
}
