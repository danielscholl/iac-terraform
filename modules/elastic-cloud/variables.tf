##############################################################
# This module allows the creation of an Elastic Cloud Kubernetes
##############################################################

variable "name" {
  type        = string
  description = "Name of helm release"
  default     = "elastic-operator"
}
variable "namespace" {
  type        = string
  description = "Name of namespace where it should be deployed"
  default     = "elastic-system"
}

variable "kubernetes_create_namespace" {
  description = "create kubernetes namespace"
  type        = bool
  default     = false
}

variable "additional_yaml_config" {
  description = "yaml config for helm chart to be processed last"
  type        = string
  default     = ""
}

variable "elasticsearch" {
  description = "Elastic Search instances configured"
  type = map(object({
    agent_pool = string
    node_count = number
    storage    = number
    cpu        = number
    memory     = number
  }))
  default = null
}
