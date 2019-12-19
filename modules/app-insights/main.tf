##############################################################
# This module allows the creation of Application Insights
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_application_insights" "main" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  application_type    = var.type
  tags                = var.resource_tags
}