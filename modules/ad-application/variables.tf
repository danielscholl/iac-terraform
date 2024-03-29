##############################################################
# This module allows the creation of a AD Application
##############################################################

variable "aad_client_id" {
  description = "Existing Application AppId."
  type        = string
  default     = ""
}

variable "name" {
  type        = string
  description = "The display name of the application"
}

variable "homepage" {
  type        = string
  default     = ""
  description = "The URL of the application's homepage."
}

variable "reply_urls" {
  type        = list(string)
  default     = []
  description = "List of URIs to which Azure AD will redirect in response to an OAuth 2.0 request."
}

variable "identifier_uris" {
  type        = list(string)
  default     = []
  description = "List of unique URIs that Azure AD can use for the application."
}

variable "sign_in_audience" {
  type        = string
  default     = "AzureADMyOrg"
  description = "Whether the application can be used from any Azure AD tenants."
}

variable "oauth2_allow_implicit_flow" {
  type        = bool
  default     = false
  description = "Whether to allow implicit grant flow for OAuth2."
}

variable "group_membership_claims" {
  type        = list(string)
  default     = ["All"]
  description = "Configures the groups claim issued in a user or OAuth 2.0 access token that the app expects."
}

variable "password" {
  type        = string
  default     = ""
  description = "The application password (aka client secret)."
}

variable "end_date" {
  type        = string
  default     = "2Y"
  description = "The RFC3339 date after which credentials expire."
}

variable "api_permissions" {
  type        = any
  default     = []
  description = "List of API permissions."
}

variable "app_roles" {
  type        = any
  default     = []
  description = "List of App roles."
}

variable "native" {
  type        = bool
  default     = false
  description = "Whether the application can be installed on a user's device or computer."
}

locals {
  homepage = format("https://%s", var.name)

  type = var.native ? "native" : "webapp/api"

  public_client = var.native ? true : false

  default_identifier_uris = [format("http://%s", var.name)]

  identifier_uris = var.native ? [] : coalescelist(var.identifier_uris, local.default_identifier_uris)

  api_permissions = [
    for p in var.api_permissions : merge({
      id                 = ""
      name               = ""
      app_roles          = []
      oauth2_permissions = []
    }, p)
  ]

  api_names = local.api_permissions[*].name

  service_principals = {
    for s in data.azuread_service_principal.main : s.display_name => {
      application_id     = s.application_id
      display_name       = s.display_name
      app_roles          = { for p in s.app_roles : p.value => p.id }
      oauth2_permissions = { for p in s.oauth2_permission_scopes : p.value => p.id }
    }
  }

  required_resource_access = var.aad_client_id != "" ? [] : [
    for a in local.api_permissions : {
      resource_app_id = local.service_principals[a.name].application_id
      resource_access = concat(
        [for p in a.oauth2_permissions : {
          id   = local.service_principals[a.name].oauth2_permissions[p]
          type = "Scope"
        }],
        [for p in a.app_roles : {
          id   = local.service_principals[a.name].app_roles[p]
          type = "Role"
        }]
      )
    }
  ]

  app_roles = [
    for r in var.app_roles : merge({
      name         = ""
      description  = ""
      member_types = []
      enabled      = true
      value        = ""
    }, r)
  ]

  date = regexall("^(?:(\\d{4})-(\\d{2})-(\\d{2}))[Tt]?(?:(\\d{2}):(\\d{2})(?::(\\d{2}))?(?:\\.(\\d+))?)?([Zz]|[\\+|\\-]\\d{2}:\\d{2})?$", var.end_date)

  duration = regexall("^(?:(\\d+)Y)?(?:(\\d+)M)?(?:(\\d+)W)?(?:(\\d+)D)?(?:(\\d+)h)?(?:(\\d+)m)?(?:(\\d+)s)?$", var.end_date)

  end_date_relative = length(local.duration) > 0 ? format(
    "%dh",
    (
      (coalesce(local.duration[0][0], 0) * 24 * 365) +
      (coalesce(local.duration[0][1], 0) * 24 * 30) +
      (coalesce(local.duration[0][2], 0) * 24 * 7) +
      (coalesce(local.duration[0][3], 0) * 24) +
      coalesce(local.duration[0][4], 0)
    )
  ) : null

  end_date = length(local.date) > 0 ? format(
    "%02d-%02d-%02dT%02d:%02d:%02d.%02d%s",
    local.date[0][0],
    local.date[0][1],
    local.date[0][2],
    coalesce(local.date[0][3], "23"),
    coalesce(local.date[0][4], "59"),
    coalesce(local.date[0][5], "00"),
    coalesce(local.date[0][6], "00"),
    coalesce(local.date[0][7], "Z")
  ) : null
}
