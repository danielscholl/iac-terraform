##############################################################
# This module allows the creation of a Function App
##############################################################

variable "name" {
  description = "The name of the function app."
  type        = string
}

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "service_plan_name" {
  description = "The name of the service plan."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "function_app_config" {
  description = "Metadata about the function apps to be created."
  type = map(object({
    image        = string
    app_settings = map(string)
  }))
  default = {}
}

variable "instrumentation_key" {
  description = "The Instrumentation Key for the Application Insights component."
  type        = string
  default     = ""
}

variable "is_always_on" {
  description = "Is the app is loaded at all times. Defaults to true."
  type        = string
  default     = true
}

variable "docker_registry_server_url" {
  description = "The docker registry server URL for images."
  type        = string
  default     = "docker.io"
}

variable "docker_registry_server_username" {
  description = "The docker registry server username for images."
  type        = string
  default     = ""
}

variable "docker_registry_server_password" {
  description = "The docker registry server password for images."
  type        = string
  default     = ""
}

variable "app_settings" {
  default     = {}
  type        = map
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

locals {
  access_restriction_description = "blocking public traffic to function app"
  access_restriction_name        = "vnet_restriction"
  app_names                      = keys(var.function_app_config)
  app_configs                    = values(var.function_app_config)

  insights_settings = var.instrumentation_key != "" ? {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.instrumentation_key
  } : {}

  docker_settings = length(compact([var.docker_registry_server_username, var.docker_registry_server_password, var.docker_registry_server_url])) == 3 ? {
    "DOCKER_REGISTRY_SERVER_URL" : format("https://%s", var.docker_registry_server_url)
    "DOCKER_REGISTRY_SERVER_USERNAME" : var.docker_registry_server_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" : var.docker_registry_server_password
  } : {}

  app_settings = merge(
    var.app_settings,
    local.insights_settings,
    local.docker_settings,
  )

  app_linux_fx_versions = [
    for config in values(var.function_app_config) :
    // Without specifyin a `linux_fx_version` the webapp created by the `azurerm_app_service` resource
    // will be a non-container webapp.
    //
    // The value of "DOCKER" is a stand-in value that can be used to force the webapp created to be
    // container compatible without explicitly specifying the image that the app should run.
    config.image == "" ? "DOCKER" : format("DOCKER|%s/%s", var.docker_registry_server_url, config.image)
  ]
}