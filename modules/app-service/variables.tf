variable "name" {
  description = "The name of the web app."
  type        = string
}

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "service_plan_name" {
  description = "The name of the service plan."
  type        = string
}

variable "app_service_config" {
  description = "Metadata about the app services to be created."
  type = map(object({
    // If "", no container configuration will be set. Otherwise, this will be used to set the container configuration for the app service.
    image = string
  }))
  default = {}
}

variable "app_settings" {
  description = "Map of App Settings."
  type        = map(string)
  default     = {}
}

variable "secure_app_settings" {
  type        = map(string)
  default     = {}
  description = "Map of sensitive app settings. Uses Key Vault references as values for app settings."
}

variable "vault_uri" {
  description = "Specifies the URI of the Key Vault resource. Providing this will create a new app setting called KEYVAULT_URI containing the uri value."
  type        = string
  default     = ""
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

variable "auth" {
  type        = any
  default     = {}
  description = "Auth settings for the web app. This should be `auth` object."
}

variable "identity" {
  type        = any
  default     = {}
  description = "Managed service identity properties. This should be `identity` object."
}

variable "custom_hostnames" {
  type        = list(string)
  default     = []
  description = "List of custom hostnames to use for the web app ActiveDirectory Provider."
}

variable "oauth_scopes" {
  type        = list(string)
  default     = []
  description = "List of oauth_scopes to use for the web app Microsoft Provider."
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

variable "allowed_ip_addresses" {
  description = "List of allowed IP Addresses"
  type        = list(string)
  default     = []
}



locals {
  access_restriction_description = "blocking public traffic to app service"
  access_restriction_name        = "vnet_restriction"
  acr_webhook_name               = "cdhook"
  app_names                      = keys(var.app_service_config)
  app_configs                    = values(var.app_service_config)

  identity = merge({
    enabled = true
    ids     = null
  }, var.identity)

  docker_settings = var.docker_registry_server_url != "" ? {
    DOCKER_REGISTRY_SERVER_URL      = format("https://%s", var.docker_registry_server_url)
    DOCKER_REGISTRY_SERVER_USERNAME = var.docker_registry_server_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.docker_registry_server_password
  } : {}

  keyvault_settings = var.vault_uri != "" ? {
    KEYVAULT_URI = var.vault_uri
  } : {}

  insights_settings = var.instrumentation_key != "" ? {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.instrumentation_key
  } : {}

  app_settings = merge(
    var.app_settings,
    local.docker_settings,
    var.secure_app_settings,
    local.insights_settings,
    {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    }
  )

  auth = merge(
    var.auth,
    {
      enabled = false
      active_directory = {
        client_id     = ""
        client_secret = ""
      }
      token_store_enabled = true
  })

  app_linux_fx_versions = [
    for config in values(var.app_service_config) :
    // Without specifyin a `linux_fx_version` the webapp created by the `azurerm_app_service` resource
    // will be a non-container webapp.
    //
    // The value of "DOCKER" is a stand-in value that can be used to force the webapp created to be
    // container compatible without explicitly specifying the image that the app should run.
    config.image == "" ? "DOCKER" : format("DOCKER|%s/%s", var.docker_registry_server_url, config.image)
  ]
}
