##############################################################
# This module allows the creation of a PostgreSQL database
##############################################################

output "db_names" {
  description = "The db names as an ordered list"
  value       = azurerm_postgresql_database.main.*.name
}

output "server_name" {
  description = "The server name"
  value       = azurerm_postgresql_server.main.name
}

output "db_ids" {
  description = "The db ids as an ordered list"
  value       = azurerm_postgresql_database.main.*.id
}

output "server_id" {
  description = "The server id."
  value       = azurerm_postgresql_server.main.id
}

output "server_fqdn" {
  description = "The server FQDN"
  value       = azurerm_postgresql_server.main.fqdn
}