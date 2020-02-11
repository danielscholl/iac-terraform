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
  name          = "${local.base_name}"
  vnet_name     = "${local.base_name}-vnet"
  cluster_name  = "${local.base_name}-cluster"

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
# Required Providers
#-------------------------------
module "provider" {
  source = "github.com/danielscholl/iac-terraform?ref=master/modules/provider"
}


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

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
    source = "github.com/danielscholl/iac-terraform/modules/network"

    name                = "iac-terraform-vnet-${module.resource_group.random}"
    resource_group_name = module.resource_group.name
    address_space       = "10.10.0.0/16"
    dns_servers         = ["8.8.8.8"]
    subnet_prefixes     = ["10.10.1.0/24"]
    subnet_names        = ["Cluster-Subnet"]
}