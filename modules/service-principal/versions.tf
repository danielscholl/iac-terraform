##############################################################
# This module allows the creation of a service-principal
##############################################################

terraform {
  required_version = "~> 0.12.20"
  required_providers {
    azuread = "~> 0.7"
    random  = "~> 2.2"
  }
}