##############################################################
# This module allows the creation of API Management Service
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_api_management" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  publisher_name      = var.organization_name
  publisher_email     = var.administrator_email
  sku_name            = "${var.tier}_${var.capacity}"
  tags                = var.resource_tags
  policy {
    xml_content = local.service_policy_is_url == false ? var.policy.content : null
    xml_link    = local.service_policy_is_url == true ? var.policy.content : null
  }
  identity {
    type = "SystemAssigned"
  }
}