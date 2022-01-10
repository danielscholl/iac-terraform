##############################################################
# This module allows the creation of a Resource Group
##############################################################

variable "name" {
  description = "The name of the Resource Group."
  type        = string
  default     = null
}

variable "names" {
  description = "Names to be applied to resources (inclusive)"
  type = object({
    environment = string
    location    = string
    product     = string
  })
  default = {
    environment = "sandbox"
    location    = "eastus2"
    product     = "iac"
  }
}

variable "location" {
  description = "The location of the Resource Group."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment tag for the Resource Group."
  type        = string
  default     = "dev"
}

variable "isLocked" {
  description = "Does the Resource Group prevent deletion?"
  type        = bool
  default     = false
}
