##############################################################
# This module allows the creation of an NGINX Ingress Controller
##############################################################

variable "helm_repository" {
  description = "nginx-ingress helm repository url"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "3.4.1"
}

variable "helm_release_name" {
  description = "helm release name"
  type        = string
}

variable "kubernetes_namespace" {
  description = "kubernetes_namespace"
  type        = string
  default     = "default"
}

variable "kubernetes_create_namespace" {
  description = "create kubernetes namespace"
  type        = bool
  default     = true
}

variable "ingress_class" {
  description = "name of the ingress class to route through this controller"
  type        = string
  default     = "nginx"
}

variable "load_balancer_ip" {
  description = "loadBalancerIP"
  type        = string
  default     = null
}

variable "replica_count" {
  description = "The number of replicas of the Ingress controller deployment."
  type        = number
  default     = 1
}

variable "enable_default_tls" {
  description = "enable default tls (requires tls_default_secret)"
  type        = string
  default     = "false"
}

variable "additional_yaml_config" {
  description = "yaml config for helm chart to be processed last"
  type        = string
  default     = ""
}

variable "ingress_type" {
  description = "Internal or Public."
  type        = string
  default     = "Public"

  validation {
    condition = (
      var.ingress_type == "Internal" ||
      var.ingress_type == "Public"
    )
    error_message = "Value of ingress_type must be one of 'Internal' or 'Public'."
  }
}