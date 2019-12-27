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

variable "auth_suffix" {
  description = "A name to be appended to all azure ad applications."
  type        = string
  default     = "easy-auth"
}




#-------------------------------
# Private Variables  (common.tf)
#-------------------------------
locals {
  // Sanitized Names
  app_id    = random_string.workspace_scope.keepers.app_id
  location  = replace(trimspace(lower(var.location)), "_", "-")
  ws_name   = random_string.workspace_scope.keepers.ws_name
  suffix    = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  // base name for resources, name constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  tenant_id = data.azurerm_client_config.current.tenant_id

  // Resolved resource names
  name                  = local.base_name
  insights_name         = "${local.base_name_83}-ai"
  service_plan_name     = "${local.base_name_83}-sp"
  app_service_name      = local.base_name_21
  ad_app_name           = "${local.base_name}-ad-app"
  

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

data "azurerm_client_config" "current" {}


#-------------------------------
# Azure Required Providers
#-------------------------------
module "provider" {
  source = "../../modules/provider"
}


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  # Module Path
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  # Module variable
  name     = local.name
  location = local.location

  resource_tags = {
    environment = local.ws_name
  }
  isLocked = true
}


#-------------------------------
# Application Insights
#-------------------------------
module "app_insights" {
  # Module Path
  source              = "github.com/danielscholl/iac-terraform/modules/app-insights"

  # Module variable
  name                = local.insights_name
  resource_group_name = module.resource_group.name
  type                = "Web"

  resource_tags = {
    environment = local.ws_name
  }
}


#-------------------------------
# Web Site
#-------------------------------
module "service_plan" {
  # Module Path
  source = "github.com/danielscholl/iac-terraform/modules/service-plan"

  # Module Variables
  name                = local.service_plan_name
  resource_group_name = module.resource_group.name
  size                = var.service_plan_size
  scaling_rules       = var.scaling_rules

  resource_tags          = {
    environment = local.ws_name
  }
}

module "app_service" {
  # Module Path
  source = "github.com/danielscholl/iac-terraform/modules/app-service"

  # Module Variables
  name                       = local.app_service_name
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  app_settings               = var.app_service_settings
  instrumentation_key        = module.app_insights.instrumentation_key
  app_service_config         = local.app_services

  resource_tags          = {
    environment = local.ws_name
  }
}


#-------------------------------
# Active Directory Application
#-------------------------------
module "ad_application" {
    source = "github.com/danielscholl/iac-terraform/modules/ad-application"

    name = local.ad_app_name
    reply_urls = flatten([
      for config in module.app_service.config_data :
      [
        format("https://%s", config.app_fqdn),
        format("https://%s/.auth/login/aad/callback", config.app_fqdn),
        format("https://%s", config.slot_fqdn),
        format("https://%s/.auth/login/aad/callback", config.slot_fqdn)
      ]
    ])
    required_resource_access = [
      {
        resource_app_id = "00000002-0000-0000-c000-000000000000" // ID for Windows Graph API
        resource_access = [
          {
            id = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7", // ID for Application.ReadWrite.OwnedBy
            type = "Role"
          }
        ]
      }
    ]
}

resource "null_resource" "auth" {
  count      = length(module.app_service.uris)
  depends_on = [module.ad_application.app_id]

  triggers = {
    app_service = join(",", module.app_service.uris)
  }

  provisioner "local-exec" {
    command = <<EOF
      az webapp auth update                     \
        --subscription "$SUBSCRIPTION_ID"       \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$APPNAME"                       \
        --enabled true                          \
        --action LoginWithAzureActiveDirectory  \
        --aad-token-issuer-url "$ISSUER"        \
        --aad-client-id "$APPID"                \
      && az webapp auth update                  \
        --subscription "$SUBSCRIPTION_ID"       \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$APPNAME"                       \
        --slot "$SLOTSHORTNAME"                 \
        --enabled true                          \
        --action LoginWithAzureActiveDirectory  \
        --aad-token-issuer-url "$ISSUER"        \
        --aad-client-id "$APPID"
      EOF

    environment = {
      SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      RESOURCE_GROUP_NAME = module.resource_group.name
      SLOTSHORTNAME = "staging"
      APPNAME = module.app_service.config_data[count.index].app_name
      ISSUER = format("https://sts.windows.net/%s", local.tenant_id)
      APPID = module.ad_application.app_id
    }
  }
}