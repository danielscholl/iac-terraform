##############################################################
# This module allows the creation of an Active Directory App
##############################################################

variable "name" {
  description = "Name of the application."
  type        = string
}

variable "type" {
  description = "Type of an application: `webapp/api` or `native`."
  default     = "webapp/api"
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

variable "identifier_uris" {
  description = "A list of user-defined URI(s) that uniquely identify a Web application within it's Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
  type        = list(string)
  default     = []
}

variable "reply_urls" {
  description = "A list of URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to."
  type        = list(string)
  default     = []
}

variable "required_resource_access" {
  description = "Required resource access for this application."
  type = list(
    object({
      resource_app_id = string,
      resource_access = list(
        object({
          id   = string,
          type = string
      }))
  }))
  default = []
}


