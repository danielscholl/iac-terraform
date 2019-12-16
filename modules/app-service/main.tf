##############################################################
# This module allows the creation of a Web App
##############################################################

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "group" {
  name = var.resource_group_name
}

data "azurerm_app_service_plan" "plan" {
  name                = var.service_plan_name
  resource_group_name = data.azurerm_resource_group.group.name
}

data "azurerm_cosmosdb_account" "account" {
  name                = var.cosmosdb_name
  resource_group_name = data.azurerm_resource_group.group.name
  count               =  var.cosmosdb_name == "" ? 0 : 1
}

resource "azurerm_app_service" "appsvc" {
  name                = format("%s-%s", var.name, lower(local.app_names[count.index]))
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  app_service_plan_id = data.azurerm_app_service_plan.plan.id
  tags                = var.resource_tags
  count               = length(local.app_names)

  app_settings = local.app_settings

  site_config {
    linux_fx_version     = local.app_linux_fx_versions[count.index]
    always_on            = var.is_always_on
    virtual_network_name = var.vnet_name
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    # This stanza will prevent terraform from reverting changes to the application container settings.
    # These settings are how application teams deploy new containers to the app service and should not
    # be overridden by Terraform deployments.
    ignore_changes = [
      site_config[0].linux_fx_version
    ]
  }
}

resource "azurerm_app_service_slot" "staging" {
  name                = "staging"
  app_service_name    = format("%s-%s", var.name, lower(local.app_names[count.index]))
  count               = length(local.app_names)
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  app_service_plan_id = data.azurerm_app_service_plan.plan.id
  depends_on          = [azurerm_app_service.appsvc]

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = format("https://%s", var.docker_registry_server_url)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_USERNAME     = var.docker_registry_server_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_server_password
    APPINSIGHTS_INSTRUMENTATIONKEY      = var.app_insights_instrumentation_key
    KEYVAULT_URI                        = var.vault_uri
  }

  site_config {
    linux_fx_version     = local.app_linux_fx_versions[count.index]
    always_on            = var.is_always_on
    virtual_network_name = var.vnet_name
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    # This stanza will prevent terraform from reverting changes to the application container settings.
    # These settings are how application teams deploy new containers to the app service and should not
    # be overridden by Terraform deployments.
    ignore_changes = [
      site_config[0].linux_fx_version
    ]
  }
}

data "azurerm_app_service" "all" {
  count               = length(azurerm_app_service.appsvc)
  name                = azurerm_app_service.appsvc[count.index].name
  resource_group_name = data.azurerm_resource_group.group.name
  depends_on          = [azurerm_app_service.appsvc]
}

resource "azurerm_template_deployment" "access_restriction" {
  name                = "access_restriction"
  count               = var.is_vnet_isolated ? length(local.app_names) : 0
  resource_group_name = data.azurerm_resource_group.group.name

  parameters = {
    service_name                   = format("%s-%s", var.name, lower(local.app_names[count.index]))
    vnet_subnet_id                 = var.vnet_subnet_id
    access_restriction_name        = local.access_restriction_name
    access_restriction_description = local.access_restriction_description
  }

  deployment_mode = "Incremental"
  template_body   = file("${path.module}/azuredeploy.json")
  depends_on      = [data.azurerm_app_service.all]
}
