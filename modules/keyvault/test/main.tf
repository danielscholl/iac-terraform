provider "azurerm" {
  version = "=2.7.0"
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "keyvault" {
  source              = "../"
  name                = "iac-terraform-kv-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}