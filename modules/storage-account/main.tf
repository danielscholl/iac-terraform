##############################################################
# This module allows the creation of a Storage Account
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "main" {
  name = lower(var.name)

  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  account_kind              = var.kind
  account_tier              = var.tier
  account_replication_type  = var.replication_type
  enable_https_traffic_only = var.ensure_https

  # enrolls storage account into azure 'managed identities' authentication
  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }
}

resource "azurerm_storage_container" "main" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.containers[count.index].access_type
}
