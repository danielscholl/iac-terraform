/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform simpleweb application.
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
  default     = "mcr.microsoft.com"
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
  base_name = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"

  // Resolved resource names
  name              = "${local.base_name}"
  service_plan_name = "${local.base_name}-plan"
  app_service_name  = "${local.base_name}"

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
# Web Site
#-------------------------------
module "service_plan" {
  # Module Path
  source = "../../modules/service-plan"

  # Module Variables
  name                = local.service_plan_name
  resource_group_name = module.resource_group.name

  resource_tags = {
    environment = local.ws_name
  }
}

module "app_service" {
  # Module Path
  source = "../../modules/app-service"

  # Module Variables
  name                       = local.app_service_name
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  app_service_config         = local.app_services
  docker_registry_server_url = local.reg_url

  resource_tags = {
    environment = local.ws_name
  }
}


#-------------------------------
# Output Variables  (output.tf)
#-------------------------------
output "app_service_default_hostname" {
  value = "https://${module.app_service.uris.0}"
}
