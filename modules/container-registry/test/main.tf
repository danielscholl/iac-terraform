provider "azurerm" {
  version = "=2.7.0"
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "container_registry" {
  source              = "../"
  name                = substr("iacterraform${module.resource_group.random}", 0, 23)
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }
}