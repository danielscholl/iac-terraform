##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################

terraform {
  required_version = ">= 0.14.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.90.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 1.2.0"
    }
  }
}