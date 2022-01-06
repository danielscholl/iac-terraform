provider "azurerm" {
  features {}
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "null_resource" "save-key" {
  triggers = {
    key = tls_private_key.key.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/.ssh
      echo "${tls_private_key.key.private_key_pem}" > ${path.module}/.ssh/id_rsa
      chmod 0600 ${path.module}/.ssh/id_rsa
    EOF
  }
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}


module "virtual_network" {
  source     = "../../network"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  resource_tags = {
    iac = "terraform"
  }

  dns_servers = ["8.8.8.8"]

  address_space = ["10.1.0.0/22"]

  subnets = {
    iaas-private = {
      cidrs                   = ["10.1.0.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
    }
    iaas-public = {
      cidrs                   = ["10.1.1.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
    }
  }

  route_tables = {
    aks = {
      disable_bgp_route_propagation = true
      use_inline_routes             = false
      routes = {
        internet = {
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
        local-vnet = {
          address_prefix = "10.1.0.0/22"
          next_hop_type  = "vnetlocal"
        }
      }
    }
  }


  # address_space = ["10.10.0.0/16"]
  # subnets = {
  #   Cluster-Subnet = {
  #     cidrs = ["10.10.1.0/24"]

  #     allow_vnet_inbound      = true
  #     allow_vnet_outbound     = true
  #     allow_internet_outbound = true
  #   }

  # }


}


module "aks" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = format("iac-terraform-cluster-%s", module.resource_group.random)
  resource_group_name = module.resource_group.name

  identity_type          = "UserAssigned"
  dns_prefix             = format("iac-terraform-cluster-%s", module.resource_group.random)
  network_plugin         = "azure"
  network_policy         = "azure"
  configure_network_role = true

  virtual_network = {
    subnets = {
      private = {
        id = module.virtual_network.subnets["iaas-private"].id
      }
      public = {
        id = module.virtual_network.subnets["iaas-public"].id
      }
    }
    route_table_id = module.virtual_network.route_tables["aks"].id
  }

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }

  default_node_pool = "system"
  node_pools = {
    system = {
      vm_size                      = "Standard_B2s"
      node_count                   = 2
      only_critical_addons_enabled = true
      subnet                       = "private"
    }
    internal = {
      vm_size             = "Standard_B2ms"
      enable_auto_scaling = true
      min_count           = 5
      max_count           = 10
      subnet              = "public"
      node_labels = {
        "pool" = "services"
      }
    }
    # spotpool = {
    #   vm_size                = "Standard_D2_v2"
    #   enable_host_encryption = false
    #   eviction_policy        = "Delete"
    #   spot_max_price         = -1
    #   priority               = "Spot"

    #   enable_auto_scaling = true
    #   min_count           = 2
    #   max_count           = 5

    #   node_labels = {
    #     "pool" = "spotpool"
    #   }
    # }
  }



  resource_tags = {
    iac = "terraform"
  }
}
