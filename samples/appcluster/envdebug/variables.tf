variable "name" {
  description = "name of helm installation (defaults to elasticsearch-<name>"
  type        = string
  default     = null
}

variable "create_namespace" {
  description = "Create the namespace for the instance if it doesn't yet exist"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Kubernetes namespace in which to create instance"
  type        = string
  default     = "default"
}

variable "agent_pool" {
  description = "AgentPool of the cluster"
  type        = string
}
