provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "network" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  dns_servers = ["8.8.8.8"]

  ## Example for AKS
  address_space = ["10.1.0.0/21"]
  subnets = {
    iaas-public = { cidrs = ["10.1.0.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    iaas-private = { cidrs = ["10.1.1.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    GatewaySubnet = { cidrs = ["10.1.2.0/24"]
      create_network_security_group = false
    }
  }
  aks_subnets = {
    kubenet = {
      private = {
        cidrs = ["10.1.3.0/25"]
      }
      public = {
        cidrs = ["10.1.3.128/25"]
      }
      route_table = {
        disable_bgp_route_propagation = true
        routes = {
          internet = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
          local-vnet-10-1-0-0-21 = {
            address_prefix = "10.1.0.0/21"
            next_hop_type  = "vnetlocal"
          }
        }
      }
    }
    azurecni = {
      private = {
        cidrs = ["10.1.4.0/24"]
      }
      public = {
        cidrs = ["10.1.5.0/24"]
      }
      route_table = {
        disable_bgp_route_propagation = true
        routes = {
          internet = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
          local-vnet-10-1-0-0-21 = {
            address_prefix = "10.1.0.0/21"
            next_hop_type  = "vnetlocal"
          }
        }
      }
    }


    ###
    ### Example for 3 Tier with NAT Gateway
    ### 

    # address_space = ["10.0.1.0/24"]
    # subnets = {
    #   Web-Tier = {
    #     cidrs = ["10.0.1.0/26"]

    #     allow_vnet_inbound      = true
    #     allow_vnet_outbound     = true
    #     allow_internet_outbound = true
    #   }
    #   App-Tier = {
    #     cidrs = ["10.0.1.64/26"]

    #     allow_vnet_inbound  = true
    #     allow_vnet_outbound = true
    #   }
    #   Data-Tier = {
    #     cidrs = ["10.0.1.128/26"]

    #     allow_vnet_inbound = true
    #   }
    #   Mgmt-Tier = {
    #     cidrs = ["10.0.1.192/27"]

    #     create_network_security_group = true
    #   }
    #   GatewaySubnet = {
    #     cidrs = ["10.0.1.224/28"]

    #     create_network_security_group = false
    #   }


  }

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
