##############################################################
# This module allows the creation of a Function App
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "main" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_app_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_function_app" "main" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.resource_tags
  count               = length(local.app_names)

  app_service_plan_id       = data.azurerm_app_service_plan.main.id
  storage_connection_string = data.azurerm_storage_account.main.primary_connection_string
  version                   = "~2"

  app_settings = merge(tomap(local.app_settings), var.function_app_config[local.app_names[count.index]].app_settings)

  site_config {
    linux_fx_version = local.app_linux_fx_versions[count.index]
    always_on        = var.is_always_on
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

