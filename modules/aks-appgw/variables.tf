##############################################################
# This module allows the creation of an Application Gateway
##############################################################

variable "name" {
  description = "The name of the application gateway."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name that the app gateway will be created in."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU for the Appication Gateway to be created"
  type        = string
  default     = "WAF_v2"
}

variable "tier" {
  description = "The tier of the application gateway. Small/Medium/Large. More details can be found at https://azure.microsoft.com/en-us/pricing/details/application-gateway/"
  type        = string
  default     = "WAF_v2"
}

variable "waf_config_firewall_mode" {
  description = "The firewall mode on the waf gateway"
  type        = string
  default     = "Prevention"
}

variable "vnet_name" {
  description = "Virtual Network name that the app gateway will be created in."
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet id that the app gateway will be created in."
  type        = string
}

variable "keyvault_id" {
  description = "Key Vault ID holding the ssl certificate used for enabling tls termination."
  type        = string
}

variable "keyvault_secret_id" {
  description = "Key Vault secret ID holding the ssl certificate used for enabling tls termination."
  type        = string
}

variable "ssl_certificate_name" {
  description = "The Name of the SSL certificate that is unique within this Application Gateway"
  type        = string
  default     = "ssl-cert"
}