##############################################################
# This module allows the creation of a Cosmos Database
##############################################################

output "endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = azurerm_cosmosdb_account.account.endpoint
}

output "name" {
  description = "The ComosDB Account Name."
  value       = azurerm_cosmosdb_account.account.name
}

output "primary_master_key" {
  description = "The Primary master key for the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.primary_master_key
  sensitive   = true
}

output "connection_strings" {
  description = "A list of connection strings available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.account.connection_strings
}
