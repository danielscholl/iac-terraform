##############################################################
# This module allows the creation of a Cosmos Database
##############################################################

data "azurerm_resource_group" "group" {
  name = var.resource_group
}

resource "azurerm_cosmosdb_account" "account" {
  name                = var.name
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name

  offer_type          = "Standard"
  kind                = var.kind

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
  name                = var.database_name
  resource_group_name = data.azurerm_resource_group.group.name
  account_name        = azurerm_cosmosdb_account.account.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.container_name
  resource_group_name = data.azurerm_resource_group.group.name
  account_name        = azurerm_cosmosdb_account.account.name
  database_name       = azurerm_cosmosdb_sql_database.database.name
  partition_key_path  = "/definition/id"

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}
