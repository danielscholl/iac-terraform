##############################################################
# This module allows the creation of an Active Directory App
##############################################################

variable "ad_config" {
  description = "Metadata about the Active Directory App to be created."
  type = list(object({
    name       = string
    reply_urls = list(string)
  }))
}

variable "type" {
  description = "Type of an application: `webapp/api` or `native`."
  default     = "webapp/api"
}

variable "resource_api_id" {
  description = "The id of the api that this app has access to."
  type        = string
}

variable "resource_role_id" {
  description = "The id of the role permission for the api that his app has access to."
  type        = string
}

variable "homepage" {
  description = "The URL to the application's home page. If no homepage is specified this defaults to `https://{name}`"
  type        = string
  default     = null
}

variable "oauth2_allow_implicit_flow" {
  description = "Does this ad application allow oauth2 implicit flow tokens?"
  type        = bool
  default     = true
}

variable "available_to_other_tenants" {
  description = "Is this ad application available to other tenants?"
  type        = bool
  default     = false
}

variable "group_membership_claims" {
  description = "Configures the groups claim issued in a user or OAuth 2.0 access token that the app expects. Possible values are `None`, `SecurityGroup` or `All`."
  default     = "SecurityGroup"
}

variable "resource_access_type" {
  description = "The type of role describing the role name of a resource access."
  type        = string
  default     = "Role"
}