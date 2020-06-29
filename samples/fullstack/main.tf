/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform micro-svc-small application.
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

variable "web_apps" {
  description = "Metadata about apps to deploy, such as image metadata."
  type = list(object({
    app_name                 = string
    image_name               = string
    image_release_tag_prefix = string
  }))
}

variable "function_apps" {
  description = "Metadata about the function apps to be created."
  type = map(object({
    image = string
  }))
  default = {}
}

variable "docker_registry_server_url" {
  description = "The url of the container registry that will be utilized to pull container into the Web Apps for containers"
  type        = string
  default     = "docker.io"
}

variable "app_service_settings" {
  description = "Map of app settings that will be applied across all provisioned app services."
  type        = map(string)
  default     = {}
}

variable "scaling_rules" {
  description = "The scaling rules for the app service plan. Schema defined here: https://www.terraform.io/docs/providers/azurerm/r/monitor_autoscale_setting.html#rule. Note, the appropriate resource ID will be auto-inflated by the template"
  type = list(object({
    metric_trigger = object({
      metric_name      = string
      time_grain       = string
      statistic        = string
      time_window      = string
      time_aggregation = string
      operator         = string
      threshold        = number
    })
    scale_action = object({
      direction = string
      type      = string
      cooldown  = string
      value     = number
    })
  }))
  default = [
    {
      metric_trigger = {
        metric_name      = "CpuPercentage"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 70
      }
      scale_action = {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT10M"
      }
      }, {
      metric_trigger = {
        metric_name      = "CpuPercentage"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 25
      }
      scale_action = {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
    }
  ]
}

variable "service_plan_size" {
  description = "The size of the service plan instance. Valid values are I1, I2, I3. See more here: . Details can be found at https://azure.microsoft.com/en-us/pricing/details/app-service/windows/"
  type        = string
  default     = "S1"
}

variable "service_plan_tier" {
  description = "The tier under which the service plan is created. Details can be found at https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans"
  type        = string
  default     = "Standard"
}

variable "cosmosdb_container_name" {
  description = "The cosmosdb container name."
  type        = string
  default     = "example"
}

variable "lock" {
  description = "Should the resource group be locked"
  default     = true
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

  // base name for resources, name constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_client_config.current.subscription_id

  // Resolved resource names
  name                   = local.base_name
  insights_name          = "${local.base_name_83}-ai"
  keyvault_name          = "${local.base_name_21}-kv"
  cosmosdb_account_name  = "${local.base_name_83}-db"
  cosmosdb_database_name = "${local.base_name_83}"
  storage_name           = "${replace(local.base_name_21, "-", "")}"
  registry_name          = "${replace(local.base_name_21, "-", "")}"
  service_plan_name      = "${local.base_name_83}-sp"
  app_service_name       = local.base_name_21
  func_app_name          = local.base_name_21
  ad_app_name            = "${local.base_name}-easyauth"
  ad_principal_name      = "${local.base_name}-principal"

  // Versions
  func_runtime = "2.0.12888.0"


  // Resolved TF Vars
  reg_url = var.docker_registry_server_url
  app_services = {
    for target in var.web_apps :
    target.app_name => {
      image = "${target.image_name}:${target.image_release_tag_prefix}"
    }
  }

  // App Services Reply URLs
  reply_urls = flatten([
    for config in module.app_service.config_data :
    [
      format("https://%s", config.app_fqdn),
      format("https://%s/.auth/login/aad/callback", config.app_fqdn),
      format("https://%s", config.slot_fqdn),
      format("https://%s/.auth/login/aad/callback", config.slot_fqdn),
      format("http://localhost:8000"),
      format("http://locahost:8000/.auth/login/aad/callback")
    ]
  ])

  contributor_scopes = concat(
    [module.service_plan.id],
    [module.cosmosdb.id],
    [module.storage_account.id],
    [module.container_registry.id],
    module.app_service.ids
  )
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

data "azurerm_client_config" "current" {}


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  # Module Path
  source = "../../modules/resource-group"

  # Module variable
  name     = local.name
  location = local.location

  resource_tags = {
    environment = local.ws_name
  }
  isLocked = var.lock
}


#-------------------------------
# Application Insights
#-------------------------------
module "app_insights" {
  # Module Path
  source = "../../modules/app-insights"

  # Module variable
  name                = local.insights_name
  resource_group_name = module.resource_group.name
  type                = "Web"

  resource_tags = {
    environment = local.ws_name
  }
}

#-------------------------------
# Cosmos Database
#-------------------------------
module "cosmosdb" {
  # Module Path
  source = "../../modules/cosmosdb"

  # Module variable
  name                     = local.cosmosdb_account_name
  resource_group_name      = module.resource_group.name
  kind                     = "GlobalDocumentDB"
  automatic_failover       = false
  consistency_level        = "Session"
  primary_replica_location = local.location
  database_name            = local.cosmosdb_database_name
  container_name           = var.cosmosdb_container_name

  resource_tags = {
    environment = local.ws_name
  }
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
    "cosmosdbName"    = module.cosmosdb.name
    "cosmosdbAccount" = module.cosmosdb.endpoint
    "cosmosdbKey"     = module.cosmosdb.primary_master_key
  }
}

module "web_keyvault_policy" {
  source = "../../modules/keyvault-policy"

  vault_id                = module.keyvault.id
  tenant_id               = module.app_service.identity_tenant_ids.0
  object_ids              = module.app_service.identity_object_ids
  key_permissions         = ["get", "list"]
  secret_permissions      = ["get", "list"]
  certificate_permissions = ["get", "list"]
}

module "func_keyvault_policy" {
  source                  = "../../modules/keyvault-policy"
  vault_id                = module.keyvault.id
  tenant_id               = module.function_app.identity_tenant_id
  object_ids              = module.function_app.identity_object_ids
  key_permissions         = ["get", "list"]
  secret_permissions      = ["get", "list"]
  certificate_permissions = ["get", "list"]
}


#-------------------------------
# Storage Account
#-------------------------------

module "storage_account" {
  source              = "../../modules/storage-account"
  resource_group_name = module.resource_group.name
  name                = substr(local.storage_name, 0, 23)
  containers = [
    {
      name        = "function-releases",
      access_type = "private"
    }
  ]
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
# Application
#-------------------------------
module "service_plan" {
  # Module Path
  source = "../../modules/service-plan"

  # Module Variables
  name                = local.service_plan_name
  resource_group_name = module.resource_group.name
  size                = var.service_plan_size
  tier                = var.service_plan_tier
  scaling_rules       = var.scaling_rules


  resource_tags = {
    environment = local.ws_name
  }
}

module "app_service" {
  # Module Path
  source = "../../modules/app-service"

  # Module Variables
  name                = local.app_service_name
  resource_group_name = module.resource_group.name
  service_plan_name   = module.service_plan.name
  instrumentation_key = module.app_insights.instrumentation_key

  app_service_config         = local.app_services
  docker_registry_server_url = local.reg_url
  app_settings = {
    cosmosdb_database = module.cosmosdb.name
    cosmosdb_account  = module.cosmosdb.endpoint
    cosmosdb_key      = module.cosmosdb.primary_master_key
  }
  secure_app_settings = module.keyvault.references

  resource_tags = {
    environment = local.ws_name
  }
}

module "function_app" {
  source               = "../../modules/function-app"
  name                 = local.func_app_name
  resource_group_name  = module.resource_group.name
  service_plan_name    = module.service_plan.name
  instrumentation_key  = module.app_insights.instrumentation_key
  storage_account_name = module.storage_account.name

  # secure_app_settings        = module.keyvault.references

  function_app_config = {
    javafunc = {
      image = "danielscholl/spring-function-app:latest"
      app_settings = {
        "FUNCTIONS_WORKER_RUNTIME"            = "java"
        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
      }
    }
  }

  resource_tags = {
    environment = local.ws_name
  }
}

#-------------------------------
# Service Principal with Role Assignments
#-------------------------------
module "service_principal" {
  source = "../../modules/service-principal"

  name = local.ad_principal_name

  scopes = local.contributor_scopes
  role   = "Contributor"
}


#-------------------------------
# Configure AD App
#-------------------------------
module "ad_application" {
  source = "../../modules/ad-application"

  ad_config = [
    {
      name       = local.ad_app_name
      reply_urls = local.reply_urls
    }
  ]
  oauth2_allow_implicit_flow = false
  available_to_other_tenants = true
  resource_access_type       = "Scope"
  resource_api_id            = "00000002-0000-0000-c000-000000000000" // ID for Windows Graph API
  resource_role_id           = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7" // ID for Application.ReadWrite.OwnedBy
}

resource "null_resource" "changed_reply_urls" {

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    app_service = join(",", local.reply_urls)
  }

  provisioner "local-exec" {
    environment = {
      URLS = join(" ", local.reply_urls)
      ID   = module.ad_application.config_data[local.ad_app_name].application_id
    }

    command = <<EOF
      az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
      az account set --subscription $ARM_SUBSCRIPTION_ID
      az ad app update --id "$ID" --reply-urls $URLS
      az logout
    EOF
  }
}

# resource "null_resource" "turn_on_easyauth" {
#   count      = length(module.app_service.uris)

#   triggers = {
#     app_service = join(",", module.app_service.uris)
#   }

#   provisioner "local-exec" {
#     # command = <<EOF
#     #   az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $TENANT_ID
#     #   az account set --subscription $SUBSCRIPTION_ID
#     #   az webapp auth update                     \
#     #     --subscription "$SUBSCRIPTION_ID"   \
#     #     --resource-group "$RESOURCE_GROUP"      \
#     #     --name "$APPNAME"                       \
#     #     --enabled true                          \
#     #     --action LoginWithAzureActiveDirectory  \
#     #     --aad-token-issuer-url "$ISSUER"        \
#     #     --aad-client-id "$APPID"                \
#     #   az webapp auth update
#     #     --subscription "$SUBSCRIPTION_ID"   \
#     #     --resource-group "$RESOURCE_GROUP"      \
#     #     --name "$APPNAME"                       \
#     #     --slot "$SLOTSHORTNAME"                 \
#     #     --enabled true                          \
#     #     --action LoginWithAzureActiveDirectory  \
#     #     --aad-token-issuer-url "$ISSUER"        \
#     #     --aad-client-id "$APPID"
#     #   az logout
#     #   EOF

#     command = <<EOF
#     echo $SUBSCRIPTION_ID
#     echo $RESOURCE_GROUP
#     echo $SLOTSHORTNAME
#     echo $APPNAME
#     echo $ISSUER
#     echo $APPID
#     EOF

#     environment = {
#       SUBSCRIPTION_ID = local.subscription_id
#       RESOURCE_GROUP = module.resource_group.name
#       SLOTSHORTNAME = "staging"
#       # APPNAME = module.app_service.config_data[count.index].app_name
#       ISSUER = format("https://sts.windows.net/%s", local.tenant_id)
#       # APPID = module.ad_application.app_ids[0]
#     }
#   }
# }


#-------------------------------
# Output Variables  (output.tf)
#-------------------------------
output "app_ids" {
  value = module.ad_application.app_ids
}

output "app_service_config_data" {
  value = module.app_service.config_data
}