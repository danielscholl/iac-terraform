##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################

variable "name" {
  description = "Name of Log Analystics Workspace. (Optional) - names override"
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group the resource will be created in"
  type        = string
}

variable "names" {
  description = "Names to be applied to resources (inclusive)"
  type = object({
    environment = string
    location    = string
    product     = string
  })
  default = {
    location    = "eastus2"
    product     = "iac"
    environment = "tf"
  }
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "naming_rules" {
  description = "naming conventions yaml file"
  type        = string
  default     = ""
}

variable "sku" {
  description = "SKU of the log analytics workspace."
  default     = "free"
}

# variable "sku" {
#   description = "Sku of the Log Analytics Workspace."
#   type        = string
#   default     = "PerGB2018"
# }

variable "retention_in_days" {
  description = "The workspace data retention in days. Between 30 and 730."
  default     = 30
}

variable "security_center_subscription" {
  description = "List of subscriptions this log analytics should collect data for."
  type        = list(string)
  default     = []
}

variable "solutions" {
  description = "A list of solutions to add to the workspace."
  type        = list(object({ solution_name = string, publisher = string, product = string }))
  default     = []
}

variable "enabled" {
  description = "Enable or not the log analytics workspace."
  default     = true
}