##############################################################
# This module allows the creation of a Web App
##############################################################

data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_app_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_app_service" "main" {
  name                = format("%s-%s", var.name, lower(local.app_names[count.index]))
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  app_service_plan_id = data.azurerm_app_service_plan.main.id
  tags                = var.resource_tags
  count               = length(local.app_names)

  app_settings = local.app_settings

  site_config {
    linux_fx_version = local.app_linux_fx_versions[count.index]
    always_on        = var.is_always_on
    dynamic "ip_restriction" {
      for_each = var.allowed_ip_addresses
      content {
        ip_address = ip_restriction.value
        # virtual_network_subnet_id = "255.255.255.255"
      }
    }
  }

  dynamic "auth_settings" {
    for_each = local.auth.enabled ? [local.auth] : []

    content {
      enabled             = auth_settings.value.enabled
      issuer              = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
      token_store_enabled = local.auth.token_store_enabled
      additional_login_params = {
        response_type = "code id_token"
        resource      = local.auth.active_directory.client_id
      }
      default_provider = "AzureActiveDirectory"
      # unauthenticated_client_action = "RedirectToLoginPage"

      dynamic "active_directory" {
        for_each = [auth_settings.value.active_directory]

        content {
          client_id     = active_directory.value.client_id
          client_secret = active_directory.value.client_secret
          allowed_audiences = formatlist("https://%s", concat(
          [format("%s.azurewebsites.net", var.name)], var.custom_hostnames))
        }
      }
    }
  }

  identity {
    type = (local.identity.enabled ?
      (local.identity.ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned") :
      "None"
    )
    identity_ids = local.identity.ids
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
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = data.azurerm_app_service_plan.main.id
  tags                = var.resource_tags
  depends_on          = [azurerm_app_service.main]

  app_settings = local.app_settings

  site_config {
    linux_fx_version = local.app_linux_fx_versions[count.index]
    always_on        = var.is_always_on
    dynamic "ip_restriction" {
      for_each = var.allowed_ip_addresses
      content {
        ip_address = ip_restriction.value
        # virtual_network_subnet_id = "255.255.255.255"
      }
    }
  }

  dynamic "auth_settings" {
    for_each = local.auth.enabled ? [local.auth] : []

    content {
      enabled             = auth_settings.value.enabled
      issuer              = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
      token_store_enabled = local.auth.token_store_enabled
      additional_login_params = {
        response_type = "code id_token"
        resource      = local.auth.active_directory.client_id
      }
      default_provider = "AzureActiveDirectory"

      dynamic "active_directory" {
        for_each = [auth_settings.value.active_directory]

        content {
          client_id     = active_directory.value.client_id
          client_secret = active_directory.value.client_secret

          allowed_audiences = formatlist("https://%s", concat(
          [format("%s.azurewebsites.net", var.name)], var.custom_hostnames))
        }
      }

      dynamic "microsoft" {
        for_each = [auth_settings.value.microsoft]

        content {
          client_id     = active_directory.value.client_id
          client_secret = active_directory.value.client_secret

          oauth_scopes = var.custom_scopes
        }
      }
    }
  }

  identity {
    type = (local.identity.enabled ?
      (local.identity.ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned") :
      "None"
    )
    identity_ids = local.identity.ids
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
  count               = length(azurerm_app_service.main)
  name                = azurerm_app_service.main[count.index].name
  resource_group_name = data.azurerm_resource_group.main.name
  depends_on          = [azurerm_app_service.main]
}
