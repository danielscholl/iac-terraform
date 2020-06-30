/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform simple cluster template.
*/

terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}

#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  version = "=2.16.0"
  features {}
}

provider "null" {
  version = "~>2.1.0"
}

provider "random" {
  version = "~>2.2"
}

provider "azuread" {
  version = "=0.10.0"
}

#-------------------------------
# Application Variables  (variables.tf)
#-------------------------------
variable "name" {
  description = "An identifier used to construct the names of all resources in this template."
  type        = string
}

variable "location" {
  description = "The Azure region where all resources in this template should be created."
  type        = string
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 8
}

variable "agent_vm_count" {
  type    = string
  default = "2"
}

variable "agent_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

#-------------------------------
# Private Variables  (common.tf)
#-------------------------------
locals {
  // Sanitized Names
  app_id   = random_string.workspace_scope.keepers.app_id
  location = replace(trimspace(lower(var.location)), "_", "-")
  ws_name  = random_string.workspace_scope.keepers.ws_name
  suffix   = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  // Base Names
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"

  // Resolved resource names
  name              = "${local.base_name}"
  vnet_name         = "${local.base_name}-vnet"
  cluster_name      = "${local.base_name}-cluster"
  registry_name     = "${replace(local.base_name_21, "-", "")}"
  keyvault_name     = "${local.base_name_21}-kv"
  ad_principal_name = "${local.base_name}-principal"
}


#-------------------------------
# Common Resources  (common.tf)
#-------------------------------
resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name = replace(trimspace(lower(terraform.workspace)), "_", "-")
    app_id  = replace(trimspace(lower(var.name)), "_", "-")
  }

  length  = max(1, var.randomization_level) // error for zero-length
  special = false
  upper   = false
}


#-------------------------------
# SSH Key
#-------------------------------
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


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  source = "../../modules/resource-group"

  name     = local.name
  location = local.location

  resource_tags = {
    environment = local.ws_name
  }
}


#-------------------------------
# Virtual Network
#-------------------------------
module "network" {
  source = "../../modules/network"

  name                = local.vnet_name
  resource_group_name = module.resource_group.name
  address_space       = "10.10.0.0/16"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.10.1.0/24"]
  subnet_names        = ["Cluster-Subnet"]
}


#-------------------------------
# Container Registry
#-------------------------------
module "container_registry" {
  source = "../../modules/container-registry"

  name                = local.registry_name
  resource_group_name = module.resource_group.name

  is_admin_enabled = false
}


#-------------------------------
# Azure Key Vault
#-------------------------------
module "keyvault" {
  # Module Path
  source = "../../modules/keyvault"

  # Module variable
  name                = local.keyvault_name
  resource_group_name = module.resource_group.name

  resource_tags = {
    environment = local.ws_name
  }
}

module "keyvault_secret" {
  # Module Path
  source = "../../modules/keyvault-secret"

  keyvault_id = module.keyvault.id
  secrets = {
    "sshKey"       = tls_private_key.key.private_key_pem
    "clientId"     = module.service_principal.client_id
    "clientSecret" = module.service_principal.client_secret
  }
}


#-------------------------------
# Service Principal with Scope
#-------------------------------
module "service_principal" {
  # Module Path
  source = "../../modules/service-principal"

  # Module Variables
  name = local.ad_principal_name
  role = "Contributor"

  scopes = concat(
    [module.network.id],
    [module.container_registry.id],
    [module.aks.id],
    [module.keyvault.id]
  )
}


#-------------------------------
# Azure Kubernetes Service
#-------------------------------
module "aks" {
  source = "../../modules/aks"

  name                     = local.cluster_name
  resource_group_name      = module.resource_group.name
  dns_prefix               = local.cluster_name
  service_principal_id     = module.service_principal.client_id
  service_principal_secret = module.service_principal.client_secret
  agent_vm_count           = var.agent_vm_count
  agent_vm_size            = var.agent_vm_size

  ssh_public_key = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  vnet_subnet_id = module.network.subnets.0

  resource_tags = {
    iac = "terraform"
  }
}


#-------------------------------
# Output Variables  (output.tf)
#-------------------------------

output "RESOURCE_GROUP" {
  value = module.resource_group.name
}

output "REGISTRY_NAME" {
  value = module.container_registry.name
}

output "CLUSTER_NAME" {
  value = local.cluster_name
}

output "PRINCIPAL_ID" {
  value = module.service_principal.client_id
}

output "PRINCIPAL_SECRET" {
  value = module.service_principal.client_secret
}

output "id_rsa" {
  value = tls_private_key.key.private_key_pem
}
