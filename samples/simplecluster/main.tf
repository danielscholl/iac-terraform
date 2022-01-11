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
  source = "github.com/danielscholl/iac-terraform.git//modules/naming-rules?ref=v1.0.0"
}

module "metadata" {
  source = "github.com/danielscholl/iac-terraform.git//modules/metadata?ref=v1.0.0"

  naming_rules = module.naming.yaml

  location    = "eastus2"
  product     = "multicluster"
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
  source = "github.com/danielscholl/iac-terraform.git//modules/resource-group?ref=v1.0.0"

  names         = module.metadata.names
  location      = module.metadata.location
  resource_tags = module.metadata.tags
}

#-------------------------------
# Virtual Network
#-------------------------------
module "network" {
  source     = "github.com/danielscholl/iac-terraform.git//modules/network?ref=v1.0.0"
  depends_on = [module.resource_group]

  naming_rules = module.naming.yaml

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags


  dns_servers   = ["8.8.8.8"]
  address_space = ["10.1.0.0/22"]

  subnets = {
    iaas-private = {
      cidrs                   = ["10.1.0.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
      service_endpoints = ["Microsoft.Storage",
        "Microsoft.AzureCosmosDB",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
      "Microsoft.EventHub"]
    }
    iaas-public = {
      cidrs                   = ["10.1.1.0/24"]
      route_table_association = "aks"
      configure_nsg_rules     = false
      service_endpoints = ["Microsoft.Storage",
        "Microsoft.AzureCosmosDB",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
      "Microsoft.EventHub"]
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

#-------------------------------
# Azure Kubernetes Service
#-------------------------------
module "kubernetes" {
  source     = "github.com/danielscholl/iac-terraform.git//modules/aks?ref=v1.0.0"
  depends_on = [module.resource_group, module.network]

  names               = module.metadata.names
  resource_group_name = module.resource_group.name
  resource_tags       = module.metadata.tags

  identity_type          = "UserAssigned"
  dns_prefix             = format("simple-cluster-%s", module.resource_group.random)
  network_plugin         = "azure"
  network_policy         = "azure"
  configure_network_role = true

  virtual_network = {
    subnets = {
      private = {
        id = module.network.subnets["iaas-private"].id
      }
      public = {
        id = module.network.subnets["iaas-public"].id
      }
    }
    route_table_id = module.network.route_tables["aks"].id
  }

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }
  default_node_pool = "system"
  node_pools = {
    system = {
      vm_size                      = "Standard_B2s"
      enable_host_encryption       = true
      node_count                   = 2
      only_critical_addons_enabled = true
      subnet                       = "private"
    }
    internal = {
      vm_size                = "Standard_B2ms"
      enable_host_encryption = true
      enable_auto_scaling    = true
      min_count              = 5
      max_count              = 10
      subnet                 = "public"
      node_labels = {
        "pool" = "services"
      }
    }
  }
}


#-------------------------------
# NGINX Ingress
#-------------------------------

# module "nginx" {
#   source     = "../../modules/nginx-ingress"
#   depends_on = [module.kubernetes]

#   name                   = "ingress-nginx"
#   namespace              = "kube-system"
#   additional_yaml_config = yamlencode({ "nodeSelector" : { "pool" : "services" } })
# }



# Temporary Direct Chart Install
resource "helm_release" "nginx" {
  depends_on = [module.kubernetes]
  name       = "nginx"
  chart      = "./charts"

  set {
    name  = "name"
    value = "nginx"
  }

  set {
    name  = "image"
    value = "nginx:latest"
  }

  set {
    name  = "nodeSelector"
    value = yamlencode({ pool = "services" })
  }
}

data "kubernetes_service" "nginx" {
  depends_on = [helm_release.nginx]
  metadata {
    name = "nginx"
  }
}

resource "azurerm_network_security_rule" "ingress_public_allow_nginx" {
  name                   = "AllowNginx"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "80"
  source_address_prefix  = "Internet"
  # destination_address_prefix  = module.nginx.load_balancer_ip
  destination_address_prefix  = data.kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
  resource_group_name         = module.network.subnets["iaas-public"].resource_group_name
  network_security_group_name = module.network.subnets["iaas-public"].network_security_group_name
}


#-------------------------------
# Container Registry
#-------------------------------
module "container_registry" {
  source     = "github.com/danielscholl/iac-terraform.git//modules/container-registry?ref=v1.0.0"
  depends_on = [module.resource_group]

  name                = local.registry_name
  resource_group_name = module.resource_group.name

  is_admin_enabled = false

  resource_tags = module.metadata.tags
}


#-------------------------------
# Azure Key Vault
#-------------------------------
# module "keyvault" {
#   # Module Path
#   source = "github.com/danielscholl/iac-terraform.git//modules/keyvault?ref=v1.0.0"
#   depends_on = [module.resource_group]

#   # Module variable
#   name                = local.keyvault_name
#   resource_group_name = module.resource_group.name

#   resource_tags = module.metadata.tags
# }

# module "keyvault_secret" {
#   # Module Path
#   source = "github.com/danielscholl/iac-terraform.git//modules/keyvault-secret?ref=v1.0.0"
#   depends_on = [module.keyvault]

#   keyvault_id = module.keyvault.id
#   secrets = {
#     "sshKey"       = tls_private_key.key.private_key_pem
#   }
# }


#-------------------------------
# Output Variables  (output.tf)
#-------------------------------

output "RESOURCE_GROUP" {
  value = module.resource_group.name
}

# output "REGISTRY_NAME" {
#   value = module.container_registry.name
# }

# output "CLUSTER_NAME" {
#   value = local.cluster_name
# }

# output "id_rsa" {
#   value = tls_private_key.key.private_key_pem
# }
