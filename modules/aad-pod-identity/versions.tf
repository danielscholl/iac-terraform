##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################

terraform {
  required_version = ">= 0.14.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.90.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}

