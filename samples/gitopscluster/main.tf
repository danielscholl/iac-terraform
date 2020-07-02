/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform simple cluster template.
*/

terraform {
  required_version = ">= 0.12"
  # backend "azurerm" {
  #   key = "terraform.tfstate"
  # }
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

provider "tls" {
  version = "=2.1"
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

###
# Begin: AKS configuration
###
variable "gitops_ssh_url" {
  type        = string
  description = "(Required) ssh git clone repository URL with Kubernetes manifests including services which runs in the cluster. Flux monitors this repo for Kubernetes manifest additions/changes periodically and apply them in the cluster."
}

# generate a SSH key named identity: ssh-keygen -q -N "" -f ./identity
# or use existing ssh public/private key pair
# add deploy key in gitops repo using public key with read/write access
# assign/specify private key to "gitops_ssh_key" variable that will be used to create kubernetes secret object
# flux uses this key to read manifests in the git repo

variable "gitops_ssh_key_file" {
  type        = string
  description = "(Required) SSH key used to establish a connection to a private git repo containing the HLD manifest."
}

variable "gitops_path" {
  type        = string
  description = "Path within git repo to locate Kubernetes manifests"
  default     = "dev"
}

variable "gitops_poll_interval" {
  type        = string
  default     = "10s"
  description = "Controls how often Flux will apply what’s in git, to the cluster, absent new commits"
}

variable "gitops_label" {
  type        = string
  default     = "flux-sync"
  description = "Label to keep track of Flux sync progress, used to tag the Git branch"
}

variable "gitops_url_branch" {
  type        = string
  description = "Branch of git repo to use for Kubernetes manifests."
  default     = "master"
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
  gateway_name      = "${local.base_name}-gw"
  cluster_name      = "${local.base_name}-cluster"
  registry_name     = "${replace(local.base_name_21, "-", "")}"
  keyvault_name     = "${local.base_name_21}-kv"
  ad_principal_name = "${local.base_name}-principal"
  ssl_cert_name     = "default-cert"
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
module "node_key" {
  source                = "../../modules/ssh-key"
  name                  = "node-ssh-key"
  ssh_public_key_path   = "./.ssh"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
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
  subnet_prefixes     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  subnet_names        = ["Frontend-Subnet", "Cluster-Subnet", "Backend-Subnet"]

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
    "nodeKey"        = module.node_key.private_key
    "nodeKeyPub"     = module.node_key.public_key
    "gitopsKeyPub"   = var.gitops_ssh_key_file
    "clientId"       = module.service_principal.client_id
    "clientSecret"   = module.service_principal.client_secret
  }
}

resource "azurerm_key_vault_certificate" "main" {
  name         = local.ssl_cert_name
  key_vault_id = module.keyvault.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "iac-terraform-gw-${module.resource_group.random}.${local.location}.cloudapp.azure.com"]
      }

      subject            = "CN=*.contoso.com"
      validity_in_months = 12
    }
  }
}

#-------------------------------
# Azure App Gateway
#-------------------------------
module "appgateway" {
  source = "../../modules/aks-appgw"

  name                 = local.gateway_name
  resource_group_name  = module.resource_group.name
  vnet_name            = module.network.name
  vnet_subnet_id       = module.network.subnets.0
  keyvault_id          = module.keyvault.id
  keyvault_secret_id   = azurerm_key_vault_certificate.main.secret_id
  ssl_certificate_name = local.ssl_cert_name

  # Tags
  resource_tags = {
    iac = "terraform"
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
    [module.keyvault.id],
    [module.network.id],
    [module.container_registry.id],
    [module.appgateway.id],
    [module.aks.id]
  )
}


#-------------------------------
# Azure Kubernetes Service
#-------------------------------
module "aks" {
  source = "../../modules/aks-gitops"

  name                     = local.cluster_name
  resource_group_name      = module.resource_group.name
  dns_prefix               = local.cluster_name
  service_principal_id     = module.service_principal.client_id
  service_principal_secret = module.service_principal.client_secret
  agent_vm_count           = var.agent_vm_count
  agent_vm_size            = var.agent_vm_size
  vnet_subnet_id           = module.network.subnets.1
  ssh_public_key           = "${trimspace(module.node_key.public_key)} k8sadmin"
  
  acr_enabled          = true
  gc_enabled           = true
  msi_enabled          = true

  gitops_ssh_url       = var.gitops_ssh_url
  gitops_ssh_key       = var.gitops_ssh_key_file
  gitops_path          = var.gitops_path
  gitops_poll_interval = var.gitops_poll_interval
  gitops_label         = var.gitops_label
  gitops_url_branch    = var.gitops_url_branch

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

output "node_key" {
  value = module.node_key.public_key
}
