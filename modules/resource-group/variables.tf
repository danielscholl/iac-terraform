##############################################################
# This module allows the creation of a Resource Group
##############################################################

variable "name" {
  description = "The name of the Resource Group."
  type    = string
}

variable "location" {
  description = "The location of the Resource Group."
  type    = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment tag for the Resource Group."
  type    = string
  default = "dev"
}
