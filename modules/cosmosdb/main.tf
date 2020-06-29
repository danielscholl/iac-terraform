##############################################################
# This module allows the creation of a Cosmos Database
##############################################################

data "azurerm_resource_group" "group" {
  name = var.resource_group_name
}

resource "azurerm_cosmosdb_account" "account" {
  name                = var.name
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  tags                = var.resource_tags

  offer_type = "Standard"
  kind       = var.kind

  enable_automatic_failover = var.automatic_failover

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.primary_replica_location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "database" {
  depends_on          = [azurerm_cosmosdb_account.account]
  count               = length(var.databases)
  name                = var.databases[count.index].name
  account_name        = azurerm_cosmosdb_account.account.name
  resource_group_name = data.azurerm_resource_group.group.name
  throughput          = var.databases[count.index].throughput
}

resource "azurerm_cosmosdb_sql_container" "container" {
  depends_on = [azurerm_cosmosdb_sql_database.database]
  count      = length(var.sql_collections)

  name                = var.sql_collections[count.index].name
  resource_group_name = data.azurerm_resource_group.group.name
  account_name        = azurerm_cosmosdb_account.account.name
  database_name       = var.sql_collections[count.index].database_name

  partition_key_path = var.sql_collections[count.index].partition_key_path
  throughput         = var.sql_collections[count.index].throughput
}
