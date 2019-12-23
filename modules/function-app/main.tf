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
  name                      = var.name
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  tags                      = var.resource_tags
  count                     = length(local.app_names)

  app_service_plan_id       = data.azurerm_app_service_plan.main.id
  storage_connection_string = data.azurerm_storage_account.main.primary_connection_string
  version                   = "~2"

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


resource "azurerm_template_deployment" "main" {
  name                = "access_restriction"
  count               = var.is_vnet_isolated ? length(local.app_names) : 0
  resource_group_name = data.azurerm_resource_group.main.name

  parameters = {
    service_name                   = format("%s-%s", var.name, lower(local.app_names[count.index]))
    vnet_subnet_id                 = var.vnet_subnet_id
    access_restriction_name        = local.access_restriction_name
    access_restriction_description = local.access_restriction_description
  }

  deployment_mode = "Incremental"
  template_body   = file("${path.module}/azuredeploy.json")
  depends_on      = [azurerm_function_app.main]
}
