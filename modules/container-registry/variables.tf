##############################################################
# This module allows the creation of a Container Registry
##############################################################

variable "name" {
  description = "The name of the Container Registry."
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
    location    = "eastus2"
    product     = "iac"
    environment = "tf"
  }
}

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "sku" {
  description = "The SKU name of the the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "is_admin_enabled" {
  description = "Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "subnet_id_whitelist" {
  description = "Represents the subnet IDs that should be allowed to access this resource"
  type        = list(string)
  default     = []
}
variable "resource_ip_whitelist" {
  description = "A list of IPs and/or IP ranges that should have access to the provisioned container registry"
  type        = list(string)
  default     = []
}
