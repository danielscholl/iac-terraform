/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform simple cluster template.
*/

terraform {
  required_version = ">= 1.1.1"

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
    helm = {
      source  = "hashicorp/helm"
      version = "=2.4.1"
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
  alias = "aks"
  debug = true
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

variable "elasticsearch" {
  description = "Elastic Search instances configured"
  type = map(object({
    agent_pool = string
    node_count = number
    storage    = number
    cpu        = number
    memory     = number
  }))
  default = {
    elastic-instance = {
      agent_pool = "public"
      node_count = 3
      storage    = 128
      cpu        = 2
      memory     = 8
    }
  }
}

variable "hostname" {
  type    = string
  default = "elasticcloud"
}

variable "email_address" {
  type    = string
  default = "admin@email.com"
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
  name          = local.base_name
  vnet_name     = "${local.base_name}-vnet"
  cluster_name  = "${local.base_name}-cluster"
  registry_name = replace(local.base_name_21, "-", "")
  keyvault_name = "${local.base_name_21}-kv"
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

module "naming" {
  source = "git::https://github.com/danielscholl/iac-terraform.git//modules/naming-rules?ref=master"
}

module "metadata" {
  source = "github.com/danielscholl/iac-terraform.git//modules/metadata?ref=v1.0.0"

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
  source = "git::https://github.com/danielscholl/iac-terraform.git//modules/resource-group?ref=v1.0.0"

  names         = module.metadata.names
  location      = module.metadata.location
  resource_tags = module.metadata.tags
}

#-------------------------------
# Virtual Network
#-------------------------------
module "network" {
  source     = "git::https://github.com/danielscholl/iac-terraform.git//modules/network?ref=v1.0.0"
  depends_on = [module.resource_group]

  naming_rules = module.naming.yaml

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags

  dns_servers   = ["8.8.8.8"]
  address_space = ["10.1.0.0/22"]

  subnets = {
    default = {
      cidrs                   = ["10.1.0.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
    }
    dev = {
      cidrs                   = ["10.1.1.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
    }
    stg = {
      cidrs                   = ["10.1.2.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
    }
    prod = {
      cidrs                   = ["10.1.3.0/24"]
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
}

resource "azurerm_public_ip" "elasticcloud" {
  name                = var.hostname
  resource_group_name = module.kubernetes.node_resource_group
  location            = module.resource_group.location
  allocation_method   = "Static"

  sku = "Standard"

  tags = module.metadata.tags
}

#-------------------------------
# Log Analytics
#-------------------------------
module "log_analytics" {
  source     = "../../modules/log-analytics"
  depends_on = [module.resource_group]

  naming_rules = module.naming.yaml

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags

  solutions = [
    {
      solution_name = "ContainerInsights",
      publisher     = "Microsoft",
      product       = "OMSGallery/ContainerInsights",
    }
  ]
}

#-------------------------------
# Azure Kubernetes Service
#-------------------------------
module "kubernetes" {
  source     = "git::https://github.com/danielscholl/iac-terraform.git//modules/aks?ref=v1.0.0"
  depends_on = [module.resource_group, module.network, module.log_analytics]

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  node_resource_group = format("%s-cluster", module.resource_group.name)
  resource_tags       = module.metadata.tags

  enable_monitoring          = true
  log_analytics_workspace_id = module.log_analytics.id

  identity_type          = "UserAssigned"
  dns_prefix             = format("elastic-cluster-%s", module.resource_group.random)
  network_plugin         = "azure"
  network_policy         = "azure"
  configure_network_role = true

  virtual_network = {
    subnets = {
      default = {
        id = module.network.subnets["default"].id
      }
      dev = {
        id = module.network.subnets["dev"].id
      }
      stg = {
        id = module.network.subnets["stg"].id
      }
      prod = {
        id = module.network.subnets["prod"].id
      }
    }
    route_table_id = module.network.route_tables["aks"].id
  }

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }
  default_node_pool = "default"
  node_pools = {
    default = {
      vm_size                = "Standard_B2s"
      enable_host_encryption = true
      node_count             = 2
      subnet                 = "default"
    }
    dev = {
      vm_size                = "Standard_B2ms"
      enable_host_encryption = true
      node_count             = 3
      subnet                 = "dev"
      enable_auto_scaling    = true
      min_count              = 3
      max_count              = 5
      node_labels = {
        "agentpool" = "dev"
      }
    }
    stg = {
      vm_size                = "Standard_B2ms"
      enable_host_encryption = true
      enable_auto_scaling    = true
      min_count              = 3
      max_count              = 5
      subnet                 = "stg"
      node_labels = {
        "agentpool" = "stg"
      }
    }
    prod = {
      vm_size                = "Standard_B2ms"
      enable_host_encryption = true
      enable_auto_scaling    = true
      min_count              = 3
      max_count              = 5
      subnet                 = "prod"
      node_labels = {
        "agentpool" = "prod"
      }
    }
  }
}

#-------------------------------
# NGINX Ingress
#-------------------------------
module "nginx" {
  source     = "git::https://github.com/danielscholl/iac-terraform.git//modules/nginx-ingress?ref=master"
  depends_on = [module.kubernetes]

  providers = { helm = helm.aks }

  name                        = "ingress-nginx"
  namespace                   = "nginx-system"
  kubernetes_create_namespace = true
  additional_yaml_config      = yamlencode({ "nodeSelector" : { "agentpool" : "default" } })
}


#-------------------------------
# AAD Pod Identity
#-------------------------------
resource "azurerm_user_assigned_identity" "appidentity" {
  name                = "${module.metadata.names.product}-appidentity"
  resource_group_name = module.resource_group.name
  location            = module.metadata.location
  tags                = module.metadata.tags
}

module "aad_pod_identity" {
  source = "../../modules/aad-pod-identity"

  depends_on = [module.kubernetes]

  providers = { helm = helm.aks }

  helm_chart_version      = "2.0.0"
  aks_node_resource_group = module.kubernetes.node_resource_group
  aks_identity            = module.kubernetes.kubelet_identity.object_id

  identities = {
    app = {
      name        = azurerm_user_assigned_identity.appidentity.name
      namespace   = "default"
      client_id   = azurerm_user_assigned_identity.appidentity.client_id
      resource_id = azurerm_user_assigned_identity.appidentity.id
    }
  }

  additional_scopes = { pod_identity = azurerm_user_assigned_identity.appidentity.id }
}


#-------------------------------
# Certficate Manager
#-------------------------------
module "certs" {
  source     = "../../modules/cert-manager"
  depends_on = [module.kubernetes, module.aad_pod_identity]

  providers = { helm = helm.aks }

  subscription_id = data.azurerm_subscription.current.subscription_id

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags

  cert_manager_version = "v0.15.1"

  issuers = {
    staging = {
      namespace            = "cert-manager"
      cluster_issuer       = true
      email_address        = var.email_address
      letsencrypt_endpoint = "staging"
    }
    production = {
      namespace            = "cert-manager"
      cluster_issuer       = true
      email_address        = var.email_address
      letsencrypt_endpoint = "production"
    }
  }
}

#-------------------------------
# Elastic Cloud Kubernetes
#-------------------------------
module "elasticcloud" {
  source     = "../../modules/elastic-cloud"
  depends_on = [module.kubernetes]

  providers = { helm = helm.aks }

  name                        = "elastic-operator"
  namespace                   = "elastic-system"
  kubernetes_create_namespace = true
  additional_yaml_config      = yamlencode({ "nodeSelector" : { "agentpool" : "default" } })

  # Elastic Search Instances
  elasticsearch = var.elasticsearch
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
