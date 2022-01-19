/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform simple cluster template.
*/

terraform {
  required_version = ">= 0.14.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "=3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.7.1"
    }
  }
}



#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.kubernetes.kube_config.host
  username               = module.kubernetes.kube_config.username
  password               = module.kubernetes.kube_config.password
  client_certificate     = base64decode(module.kubernetes.kube_config.client_certificate)
  client_key             = base64decode(module.kubernetes.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.kubernetes.kube_config.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes.kube_config.host
    username               = module.kubernetes.kube_config.username
    password               = module.kubernetes.kube_config.password
    client_certificate     = base64decode(module.kubernetes.kube_config.client_certificate)
    client_key             = base64decode(module.kubernetes.kube_config.client_key)
    cluster_ca_certificate = base64decode(module.kubernetes.kube_config.cluster_ca_certificate)
  }
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
  base_name    = "${module.metadata.names.product}-${module.metadata.names.environment}-${module.metadata.names.location}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"

  // Manual Naming Conventions
  name          = local.base_name
  registry_name = "${replace(local.base_name_21, "-", "")}cr"
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

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "azurerm_subscription" "current" {
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
# Naming Guidelines
#-------------------------------

module "naming" {
  source = "git::https://github.com/danielscholl/iac-terraform.git//modules/naming-rules?ref=v1.0.1"
}

module "metadata" {
  source = "git::https://github.com/danielscholl/iac-terraform.git//modules/metadata?ref=v1.0.1"

  naming_rules = module.naming.yaml

  location    = var.location
  product     = var.name
  environment = "sandbox"

  additional_tags = {
    "repo"  = "https://github.com/danielscholl/iac-terraform"
    "owner" = "Daniel Scholl"
  }
}


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform.git//modules/resource-group?ref=v1.0.1"

  name     = local.name
  location = local.location
  resource_tags = {
    environment = local.ws_name
  }
}

#-------------------------------
# Container Registry
#-------------------------------
module "registry" {
  source     = "git::https://github.com/danielscholl/iac-terraform.git//modules/container-registry?ref=v1.0.1"
  depends_on = [module.resource_group]

  name                = local.registry_name
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags
}


#-------------------------------
# Azure Kubernetes Service
#-------------------------------
module "kubernetes" {
  source     = "github.com/danielscholl/iac-terraform.git//modules/aks?ref=v1.0.1"
  depends_on = [module.resource_group]

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  node_resource_group = format("%s-cluster", module.resource_group.name)
  resource_tags       = module.metadata.tags

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }

  node_pools = {
    default = {
      vm_size                = "Standard_B2s"
      enable_host_encryption = true
      node_count             = 2
    }
  }

  acr_pull_access = {
    acr = module.registry.id
  }
}

#-------------------------------
# Output Variables  (output.tf)
#-------------------------------

output "RESOURCE_GROUP" {
  value = module.resource_group.name
}

output "CLUSTER_NAME" {
  value = module.kubernetes.name
}

output "REGISTRY_NAME" {
  value = module.registry.name
}
