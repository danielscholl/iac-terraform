##############################################################
# This module allows the creation of a Key Vault
##############################################################

variable "name" {
  description = "Name of the keyvault to create"
  type        = string
  default     = "spkeyvault"
}

variable "resource_group" {
  type        = string
  description = "Default resource group name that the keyvault will be created in."
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "SKU of the keyvault to create"
  type        = string
  default     = "standard"
}

variable "key_permissions" {
  description = "Permissions that the service principal has for accessing keys from keyvault"
  type        = list(string)
  default     = ["create", "delete", "get"]
}

variable "secret_permissions" {
  description = "Permissions that the service principal has for accessing secrets from keyvault"
  type        = list(string)
  default     = ["set", "delete", "get", "list"]
}

variable "certificate_permissions" {
  description = "Permissions that the service principal has for accessing certificates from keyvault"
  type        = list(string)
  default     = ["create", "delete", "get", "list"]
}

variable "subnet_id_whitelist" {
  description = "If supplied this represents the subnet IDs that should be allowed to access this resource"
  type        = list(string)
  default     = []
}

variable "resource_ip_whitelist" {
  description = "A list of IPs and/or IP ranges that should have access to the provisioned keyvault"
  type        = list(string)
  default     = []
}
