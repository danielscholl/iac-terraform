##############################################################
# This module allows the creation of a Resource Group
##############################################################

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
  tags     = var.resource_tags
}

resource "random_id" "main" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.main.name
  }

  byte_length = 8
}

resource "azurerm_management_lock" "main" {
  count = var.isLocked ? 1 : 0
  name       = "${azurerm_resource_group.main.name}-delete-lock"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"

  lifecycle {
    prevent_destroy = true
  }
}
