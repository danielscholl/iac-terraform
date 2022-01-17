##############################################################
# This module allows the creation of an Elastic Cloud Kubernetes
##############################################################

variable "name" {
  type        = string
  description = "Name of helm release"
  default     = "ingress-nginx"
}
variable "namespace" {
  type        = string
  description = "Name of namespace where it should be deployed"
  default     = "kube-system"
}

variable "operator_version" {
  type        = string
  description = "HELM Chart Version for the operator"
  default     = "1.9.1"
}

variable "kubernetes_create_namespace" {
  description = "create kubernetes namespace"
  type        = bool
  default     = false
}
