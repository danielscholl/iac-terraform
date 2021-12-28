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

module "network" {
  source     = "../../network"
  depends_on = [module.resource_group]

  name                = format("iac-terraform-vnet-%s", module.resource_group.random)
  resource_group_name = module.resource_group.name
  address_space       = "10.10.0.0/16"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.10.1.0/24"]
  subnet_names        = ["Cluster-Subnet"]
}


data "azurerm_client_config" "current" {}

module "aks" {
  source = "../"
  depends_on = [module.resource_group, module.network]

  name                     = format("iac-terraform-cluster-%s", module.resource_group.random)
  resource_group_name      = module.resource_group.name
  dns_prefix               = format("iac-terraform-cluster-%s", module.resource_group.random)

  ssh_public_key = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  vnet_subnet_id = module.network.subnets.0

  identity_type = "UserAssigned"

  resource_tags = {
    iac = "terraform"
  }
}
