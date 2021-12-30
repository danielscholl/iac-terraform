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

resource "random_password" "admin" {
  length  = 14
  special = true
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

data "azurerm_client_config" "current" {}

module "aks" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = format("iac-terraform-cluster-%s", module.resource_group.random)
  resource_group_name = module.resource_group.name
  dns_prefix          = format("iac-terraform-cluster-%s", module.resource_group.random)

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }

  default_node_pool = "default"
  node_pools = {
    default = {
      vm_size                = "Standard_B2s"
      enable_host_encryption = true

      node_count = 3
    }
    spotpool = {
      vm_size                = "Standard_D2_v2"
      enable_host_encryption = false
      eviction_policy        = "Delete"
      spot_max_price         = -1
      priority               = "Spot"

      enable_auto_scaling = true
      min_count           = 2
      max_count           = 5

      node_labels = {
        "pool" = "spotpool"
      }
    }
  }

  resource_tags = {
    iac = "terraform"
  }
}
