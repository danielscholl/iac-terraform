##############################################################
# This module allows the creation of an Active Directory App
##############################################################


resource "azuread_application" "main" {
  count                      = length(var.ad_config)
  name                       = var.ad_config[count.index].name
  type                       = var.type
  homepage                   = var.homepage
  reply_urls                 = var.ad_config[count.index].reply_urls
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = var.oauth2_allow_implicit_flow
  group_membership_claims    = var.group_membership_claims

  required_resource_access {
    resource_app_id = var.resource_api_id

    resource_access {
      id   = var.resource_role_id
      type = var.resource_access_type
    }
  }

  lifecycle {
    ignore_changes = [
      reply_urls
    ]
    create_before_destroy = true
  }

}

data "azuread_application" "main" {
  count      = length(var.ad_config)
  depends_on = [azuread_application.main]
  object_id  = azuread_application.main[count.index].object_id
}
