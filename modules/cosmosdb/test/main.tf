/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform web-data application.
*/

terraform {
  required_version = ">= 0.12"
}

#-------------------------------
# Application Variables  (variables.tf)
#-------------------------------
variable "prefix" {
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
  default     = "centralus"
}

variable "cosmosdb_replica_location" {
  description = "The name of the Azure region to host replicated data. i.e. 'East US' 'East US 2'. More locations can be found at https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
  default     = "eastus2"
}

variable "cosmosdb_automatic_failover" {
  description = "Determines if automatic failover is enabled for CosmosDB."
  type        = bool
  default     = true
}

variable "cosmos_databases" {
  description = "The list of Cosmos DB SQL Databases."
  type = list(object({
    name       = string
    throughput = number
  }))
  default = []
}

variable "cosmos_sql_collections" {
  description = "The list of cosmos collection names to create. Names must be unique per cosmos instance."
  type = list(object({
    name               = string
    database_name      = string
    partition_key_path = string
    throughput         = number
  }))
  default = []
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

  // base prefix for resources, prefix constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  tenant_id = data.azurerm_client_config.current.tenant_id

  // Resource names
  app_rg_name                 = "${local.base_name_83}-app-rg"              // app resource group (max 90 chars)
  app_rg_lock                 = "${local.base_name_83}-app-rg-delete-lock"  // management lock to prevent deletes
  cosmosdb_name               = "${local.base_name_21}-cosmosdb"            // cosmosdb account (max 44 chars )
  cosmos_db_name              = "dev-osdu-r2-db"
  throughput = 400
  cosmos_database = {
    name       = local.cosmos_db_name
    throughput = local.throughput
  }
  cosmos_sql_collections = [
    {
      name               = "LegalTag"
      database_name      = local.cosmos_db_name
      partition_key_path = "/id"
      throughput         = local.throughput
    },
    {
      name               = "StorageRecord"
      database_name      = local.cosmos_db_name
      partition_key_path = "/id"
      throughput         = local.throughput
    },
    {
      name               = "StorageSchema"
      database_name      = local.cosmos_db_name
      partition_key_path = "/kind"
      throughput         = local.throughput
    },
    {
      name               = "TenantInfo"
      database_name      = local.cosmos_db_name
      partition_key_path = "/id"
      throughput         = local.throughput
    },
    {
      name               = "UserInfo"
      database_name      = local.cosmos_db_name
      partition_key_path = "/id"
      throughput         = local.throughput
    }
  ]
}


#-------------------------------
# Azure Required Providers
#-------------------------------
provider "azurerm" {
  version = "=2.7.0"  // version = "~>1.40.0"
  features {}
}

#-------------------------------
# Application Resources  (common.tf)
#-------------------------------
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name = replace(trimspace(lower(terraform.workspace)), "_", "-")
    app_id  = replace(trimspace(lower(var.prefix)), "_", "-")
  }

  length  = max(1, var.randomization_level) // error for zero-length
  special = false
  upper   = false
}




#-------------------------------
# Resource Group
#-------------------------------
resource "azurerm_resource_group" "app_rg" {
  name     = local.app_rg_name
  location = local.region
}



#-------------------------------
# Cosmos Database
#-------------------------------
module "cosmosdb_account" {
  # Module Path
  source                   = "../"

  # Module variable
  name                     = local.cosmos_db_name
  resource_group_name      = azurerm_resource_group.app_rg.name
  primary_replica_location = var.cosmosdb_replica_location
  automatic_failover       = var.cosmosdb_automatic_failover
  consistency_level        = "Session"
  kind                     = "GlobalDocumentDB"
  databases                = [local.cosmos_database]
  sql_collections          = local.cosmos_sql_collections
}

#-------------------------------
# Output Variables  (output.tf)
#-------------------------------

# output "cosmosdb_properties" {
#   description = "Properties of the deployed CosmosDB account."
#   value       = module.cosmosdb_account.properties
#   sensitive   = true
# }

# output "cosmosdb_account_name" {
#   description = "The name of the CosmosDB account."
#   value       = module.cosmosdb_account.account_name
# }

# output "cosmosdb_conn_string_kv_secret_name" {
#   description = "Secret name storing the primary connection string for CosmosDB."
#   value       = "cosmos-connection"
# }