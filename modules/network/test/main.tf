provider "azurerm" {
  features {}
}


module "resource_group" {
  source = "../../resource-group"

  name = "iac-terraform"
  location = "eastus2"

  resource_tags = {
    iac = "terraform"
  }
}

module "network" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  dns_servers = ["8.8.8.8"]
  address_space = ["10.0.1.0/24"]
  subnets = {
    Web-Tier = {
      cidrs = ["10.0.1.0/26"]

      allow_vnet_inbound      = true
      allow_vnet_outbound     = true
      allow_internet_outbound = true
    }
    App-Tier = {
      cidrs = ["10.0.1.64/26"]

      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    Data-Tier = {
      cidrs = ["10.0.1.128/26"]

      allow_vnet_inbound = true
    }
    Mgmt-Tier = {
      cidrs = ["10.0.1.192/27"]

      create_network_security_group = true
    }
    GatewaySubnet = {
      cidrs = ["10.0.1.224/28"]

      create_network_security_group = false
    }
  }

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
