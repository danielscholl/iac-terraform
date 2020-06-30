provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "keyvault" {
  source              = "../../keyvault"
  name                = substr("iac-terraform-kv-${module.resource_group.random}", 0, 23)
  resource_group_name = module.resource_group.name
}

module "keyvault_secret" {
  source      = "../"
  keyvault_id = module.keyvault.id
  secrets = {
    "iac" : "terraform"
  }
}