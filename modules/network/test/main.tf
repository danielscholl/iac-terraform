provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}


module "network" {
  source = "../"

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  address_space       = "10.0.1.0/24"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26", "10.0.1.192/27", "10.0.1.224/28"]
  subnet_names        = ["Web-Tier", "App-Tier", "Data-Tier", "Mgmt-Tier", "GatewaySubnet"]

  # Tags
  resource_tags = {
    iac = "terraform"
  }

}