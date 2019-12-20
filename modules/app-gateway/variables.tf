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
  default     = "WAF_Medium"
}

variable "tier" {
  description = "The tier of the application gateway. Small/Medium/Large. More details can be found at https://azure.microsoft.com/en-us/pricing/details/application-gateway/"
  type        = string
  default     = "WAF"
}

variable "capacity" {
  description = "The capacity of application gateway to be created"
  type        = number
  default     = 2
}


variable "vnet_name" {
  description = "Virtual Network name that the app gateway will be created in."
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet id that the app gateway will be created in."
  type        = string
}

variable "public_pip_id" {
  description = "the public ip resource id of the frontend configuration"
  type        = string
}

variable "ipconfig_name" {
  description = "The IP Config Name for the Appication Gateway to be created"
  type        = string
  default     = "subnet"
}

variable "ssl_private_pfx" {
  description = "PFX certificate"
  type        = string
}

variable "ssl_public_cert" {
  description = "The contents of the Authentication Certificate which should be used"
  type        = string
}


variable "frontend_port_name" {
  description = "The Frontend Port Name for the Appication Gateway to be created"
  type        = string
  default     = "https-frontend-port"
}

variable "frontend_http_port" {
  description = "The frontend port for the Appication Gateway to be created"
  type        = number
  default     = 443
}

variable "frontend_ip_configuration_name" {
  description = "The Frontend IP configuration name for the Appication Gateway to be created"
  type        = string
  default     = "frontend"
}

variable "backend_address_pool_name" {
  description = "The Backend Addres Pool Name for the Appication Gateway to be created"
  type        = string
  default     = "backend_pool"
}

variable "backend_http_setting_name" {
  description = "The Backend Http Settings Name for the Appication Gateway to be created"
  type        = string
  default     = "backend_settings"
}

variable "backend_http_cookie_based_affinity" {
  description = "The Backend Http cookie based affinity for the Appication Gateway to be created"
  type        = string
  default     = "Disabled"
}

variable "backend_http_port" {
  description = "The backend port for the Appication Gateway to be created"
  type        = number
  default     = 443
}

variable "backend_http_protocol" {
  description = "The backend protocol for the Appication Gateway to be created"
  type        = string
  default     = "Https"
}

variable "http_listener_protocol" {
  description = "The Http Listener protocol for the Appication Gateway to be created"
  type        = string
  default     = "Https"
}

variable "listener_name" {
  description = "The Listener Name for the Appication Gateway to be created"
  type        = string
  default     = "http_proxy_listener"
}

variable "request_routing_rule_name" {
  description = "The rule name to request routing for the Appication Gateway to be created"
  type        = string
  default     = "request_proxy_routing_rule"
}

variable "request_routing_rule_type" {
  description = "The rule type to request routing for the Appication Gateway to be created"
  type        = string
  default     = "Basic"
}

variable "waf_config_firewall_mode" {
  description = "The firewall mode on the waf gateway"
  type        = string
  default     = "Prevention"
}

variable "backendpool_fqdns" {
  description = "A list of FQDN's which should be part of the Backend Address Pool."
  type        = list(string)
  default     = []
}