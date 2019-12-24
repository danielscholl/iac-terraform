##############################################################
# This module allows the creation of an Active Directory App
##############################################################


resource "azuread_application" "main" {
  name                       = var.name
  homepage                   = var.homepage
  identifier_uris            = var.identifier_uris
  reply_urls                 = var.reply_urls
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = var.oauth2_allow_implicit_flow
  type                       = var.type
  group_membership_claims    = var.group_membership_claims

  dynamic "required_resource_access" {
    for_each = var.required_resource_access
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
