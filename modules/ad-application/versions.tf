##############################################################
# This module allows the creation of a service-principal
##############################################################

terraform {
  required_version = "~> 0.12.8"
  required_providers {
    azuread = "~> 0.6"
  }
}