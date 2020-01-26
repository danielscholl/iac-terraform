##############################################################
# This module allows the creation of a service-principal
##############################################################

terraform {
  required_version = "~> 0.12.19"
  required_providers {
    azuread = "~> 0.7"
    azurerm = "~> 1.40"
    random  = "~> 2.2"
  }
}