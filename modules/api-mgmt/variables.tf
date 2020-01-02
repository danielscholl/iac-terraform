##############################################################
# This module allows the creation of API Management Service
##############################################################

variable "name" {
  description = "The name that API Management Service will be created with."
  type        = string
}

variable "resource_group_name" {
  description = "The Resource group to contain the API Management Service"
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "organization_name" {
  description = "The email address of the owner of the service"
  type        = string
}

variable "administrator_email" {
  description = "The name of the owner of the service"
  type        = string
}

variable "tier" {
  description = "The pricing tier of this API Management service"
  type        = string
  default     = "Developer"
}

variable "capacity" {
  description = "The instance size of this API Management service."
  type        = number
  default     = 1
}

variable "policy" {
  description = "Service policy xml content and format. Content can be inlined xml or a url"
  type = object({
    content = string
    format  = string
  })
  default = {
    content = <<XML
<policies>
    <inbound />
    <backend />
    <outbound />
    <on-error />
</policies>
XML
    format  = "xml"
  }
}

locals {
  service_policy_is_url = replace(var.policy.format, "link", "") != var.policy.format
}