##############################################################
# This module allows the creation of a service-principal
##############################################################

resource "random_password" "main" {
  count   = var.password == "" ? 1 : 0
  length  = 32
  special = false
}

data "azuread_service_principal" "main" {
  count        = length(local.api_names)
  display_name = local.api_names[count.index]
}

resource "azuread_application" "main" {
  count                      = local.create_count
  name                       = var.name
  available_to_other_tenants = false

  dynamic "required_resource_access" {
    for_each = local.required_resource_access
    iterator = resource
    content {
      resource_app_id = resource.value.resource_app_id

      dynamic "resource_access" {
        for_each = resource.value.resource_access
        iterator = access
        content {
          id   = access.value.id
          type = access.value.type
        }
      }
    }
  }
}

resource "azuread_service_principal" "main" {
  count          = local.create_count
  application_id = azuread_application.main[0].application_id
}

resource "azurerm_role_assignment" "main" {
  count                = length(var.scopes)
  role_definition_name = var.role
  principal_id         = var.create_for_rbac == true ? azuread_service_principal.main[0].object_id : var.object_id
  scope                = var.scopes[count.index]
}

resource "azuread_service_principal_password" "main" {
  count                = var.password != null ? 1 : 0
  service_principal_id = azuread_service_principal.main[0].id

  value             = coalesce(var.password, random_password.main[0].result)
  end_date          = local.end_date
  end_date_relative = local.end_date_relative

  lifecycle {
    ignore_changes = all
  }
}
