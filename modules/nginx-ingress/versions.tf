##############################################################
# This module allows the creation of an NGINX Ingress Controller
##############################################################

terraform {
  required_version = ">= 0.14.11"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.7.1"
    }
  }
}