##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.name != null ? var.name : local.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.resource_tags
}

resource "azurerm_security_center_workspace" "main" {
  count = length(var.security_center_subscription)

  scope        = "/subscriptions/${element(var.security_center_subscription, count.index)}"
  workspace_id = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_log_analytics_solution" "main" {
  count = length(var.solutions)

  solution_name         = var.solutions[count.index].solution_name
  resource_group_name   = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = var.solutions[count.index].publisher
    product   = var.solutions[count.index].product
  }
}
