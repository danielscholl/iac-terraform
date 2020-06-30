##############################################################
# This module allows the creation of a Storage Account
##############################################################

variable "name" {
  description = "The name of the Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "kind" {
  description = "The type of the Storage Account. Use StorageV2 when possible."
  type        = string
  default     = "StorageV2"
}

variable "tier" {
  description = "The performance level of the Storage Account."
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "The type of replication for the Storage Account. Valid options are LRS*, GRS, RAGRS and ZRS."
  type        = string
  default     = "LRS"
}

variable "ensure_https" {
  description = "Boolean flag which forces HTTPS in order to ensure secure connections."
  type        = bool
  default     = true
}

variable "containers" {
  type = list(object({
    name        = string
    access_type = string
  }))
  description = "List of storage containers."
  default     = []
}

variable "assign_identity" {
  type        = bool
  description = "Set to `true` to enable system-assigned managed identity, or `false` to disable it."
  default     = true
}
