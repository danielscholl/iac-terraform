/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the Terraform spring-api-user application.
*/

terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}

#-------------------------------
# Application Variables  (variables.tf)
#-------------------------------
variable "name" {
  description = "An identifier used to construct the names of all resources in this template."
  type        = string
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 8
}

variable "resource_group_location" {
  description = "The Azure region where all resources in this template should be created."
  type        = string
}

variable "deployment_targets" {
  description = "Metadata about apps to deploy, such as image metadata."
  type = list(object({
    app_name                 = string
    image_name               = string
    image_release_tag_prefix = string
  }))
}

variable "docker_registry_server_url" {
  description = "The url of the container registry that will be utilized to pull container into the Web Apps for containers"
  type        = string
  default     = "docker.io"
}


#-------------------------------
# Application Resources  (common.tf)
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
# Private Variables  (common.tf)
#-------------------------------
locals {
  // sanitize names
  app_id  = random_string.workspace_scope.keepers.app_id
  region  = replace(trimspace(lower(var.resource_group_location)), "_", "-")
  ws_name = random_string.workspace_scope.keepers.ws_name
  suffix  = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  // base name for resources, name constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  // Resolved resource names
  app_rg_name             = "${local.base_name_83}-api"
  kv_name                 = "${local.base_name_21}-kv"
  cosmosdb_account_name   = "${local.base_name}-db"
  cosmosdb_database_name  = "${var.name}-api"
  cosmosdb_container_name = "user"
  sp_name                 = "${local.base_name}-plan"
  app_svc_name            = "${local.base_name}"

  // Resolved TF Vars
  reg_url = var.docker_registry_server_url
  app_services = {
    for target in var.deployment_targets :
    target.app_name => {
      image = "${target.image_name}:${target.image_release_tag_prefix}"
    }
  }
}


#-------------------------------
# Azure Required Providers
#-------------------------------
module "provider" {
  source = "./modules/provider"
}


#-------------------------------
# Application Resource Group
#-------------------------------
module "resourcegroup" {
  # Module Path
  source = "./modules/resource-group"

  # Module variable
  name        = local.app_rg_name
  location    = local.region
  environment = local.ws_name
}


#-------------------------------
# Azure Key Vault
#-------------------------------
module "keyvault" {
  # Module Path
  source = "./modules/keyvault"

  # Module variable
  name           = local.kv_name
  resource_group = module.resourcegroup.name
}


#-------------------------------
# Cosmos Database
#-------------------------------
module "cosmosdb" {
  # Module Path
  source = "./modules/cosmosdb"

  # Module variable
  name                     = local.cosmosdb_account_name
  resource_group           = module.resourcegroup.name
  kind                     = "GlobalDocumentDB"
  database_name            = local.cosmosdb_database_name
  container_name           = local.cosmosdb_container_name
  automatic_failover       = false
  consistency_level        = "Session"
  primary_replica_location = module.resourcegroup.location
}


#-------------------------------
# Web Site
#-------------------------------
module "service_plan" {
  # Module Path
  source = "./modules/service-plan"

  # Module variable
  name           = local.sp_name
  resource_group = module.resourcegroup.name
}

module "app_service" {
  # Module Path
  source = "./modules/app-service"

  # Module variable
  name                       = local.app_svc_name
  resource_group             = module.resourcegroup.name
  service_plan_name          = module.service_plan.name
  app_service_config         = local.app_services
  docker_registry_server_url = local.reg_url
  cosmosdb_name              = module.cosmosdb.name
}


output "app_service_default_hostname" {
  value = "https://${element(module.app_service.uris, 0)}"
}
