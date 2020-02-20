##############################################################
# This module allows the creation of a AD Application
##############################################################

terraform {
  required_version = "~> 0.12.20"
  required_providers {
    azuread = "~> 0.7"
  }
}