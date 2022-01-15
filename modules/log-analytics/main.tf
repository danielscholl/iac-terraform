##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################

locals {
  id = element(
    concat(
      azurerm_log_analytics_workspace.free.*.id,
      azurerm_log_analytics_workspace.nonfree.*.id,
      tolist([""])
      # list("")
    ),
    0
  )
  workspace_name = element(
    concat(
      azurerm_log_analytics_workspace.free.*.name,
      azurerm_log_analytics_workspace.nonfree.*.name,
      tolist([""])
    ),
    0
  )
  name = "${var.names.product}-${var.names.environment}-${var.names.location}-vnet"
}


data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}


resource "azurerm_log_analytics_workspace" "nonfree" {
  count               = var.enabled && var.sku != "free" ? 1 : 0
  name                = local.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.resource_tags
}

resource "azurerm_log_analytics_workspace" "free" {
  count               = var.enabled && var.sku == "free" ? 1 : 0
  name                = local.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.sku

  tags = var.resource_tags
}


# resource "azurerm_log_analytics_workspace" "main" {
#   name                = var.name != null ? var.name : local.name
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   sku                 = var.sku
#   retention_in_days   = var.retention_in_days

#   tags = var.resource_tags
# }

resource "azurerm_security_center_workspace" "main" {
  count = length(var.security_center_subscription)

  scope        = "/subscriptions/${element(var.security_center_subscription, count.index)}"
  workspace_id = local.id
}

resource "azurerm_log_analytics_solution" "main" {
  count = length(var.solutions)

  solution_name         = var.solutions[count.index].solution_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  workspace_resource_id = local.id
  workspace_name        = local.workspace_name

  plan {
    publisher = var.solutions[count.index].publisher
    product   = var.solutions[count.index].product
  }
}