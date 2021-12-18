##############################################################
# This module allows the creation of a AD Application
##############################################################

data "azuread_service_principal" "main" {
  count        = length(local.api_names)
  display_name = local.api_names[count.index]
}

resource "azuread_application" "main" {
  display_name = var.name
  # identifier_uris                = local.identifier_uris
  fallback_public_client_enabled = local.public_client

  web {
    homepage_url  = coalesce(var.homepage, local.homepage)
    redirect_uris = var.reply_urls

    implicit_grant {
      access_token_issuance_enabled = var.oauth2_allow_implicit_flow
    }
  }

  dynamic "required_resource_access" {
    for_each = local.required_resource_access

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access

        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = local.app_roles

    content {
      id                   = app_role.value.id
      allowed_member_types = app_role.value.member_types
      display_name         = app_role.value.name
      description          = app_role.value.description
      value                = coalesce(app_role.value.value, app_role.value.name)
      enabled              = app_role.value.enabled
    }
  }
}

resource "random_password" "main" {
  count   = var.password == "" ? 1 : 0
  length  = 32
  special = false
}

resource "azuread_application_password" "main" {
  count                 = var.password != null ? 1 : 0
  application_object_id = azuread_application.main.id

  end_date          = local.end_date
  end_date_relative = local.end_date_relative

  lifecycle {
    ignore_changes = all
  }
}
