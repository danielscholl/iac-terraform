provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "network" {
  source     = "../../network"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  address_space       = "10.0.1.0/24"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.0.1.0/26"]
  subnet_names        = ["Web-Tier"]

  # Tags
  resource_tags = {
    iac = "terraform"
  }

}

module "postgreSQL" {
  source     = "../"
  depends_on = [module.resource_group]

  resource_group_name = module.resource_group.name
  name                = "iac-terraform-db-${module.resource_group.random}"
  databases           = ["iac-terraform-database"]
  admin_user          = "test"
  admin_password      = "AzurePassword@123"

  # Tags
  resource_tags = {
    iac = "terraform"
  }

  firewall_rules = [{
    start_ip = "10.0.0.2"
    end_ip   = "10.0.0.8"
  }]

  vnet_rules = [{
    subnet_id = module.network.subnets[0]
  }]

  postgresql_configurations = {
    config = "test"
  }
}
