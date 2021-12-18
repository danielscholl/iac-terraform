
variable "name" {
  description = "The name of the event grid domain."
  type        = string
}

variable "resource_group_name" {
  description = "The name of an existing resource group that service bus will be provisioned"
  type        = string
}

variable "sku" {
  description = "The SKU of the namespace. The options are: `Basic`, `Standard`, `Premium`."
  type        = string
  default     = "Standard"
}

variable "resource_tags" {
  description = " A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "topics" {
  type        = any
  default     = []
  description = "List of topics."
}