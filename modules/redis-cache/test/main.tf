provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "redis-cache" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-redis-cache-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }

}
