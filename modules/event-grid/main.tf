
locals {

  topics = [
    for topic in var.topics : merge({
      name = ""

    }, topic)
  ]

}

## define resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_eventgrid_domain" "main" {
  name = var.name

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = var.resource_tags
}

resource "azurerm_eventgrid_topic" "main" {
  count = length(local.topics)

  name                = local.topics[count.index].name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = var.resource_tags
}

