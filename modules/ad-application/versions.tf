##############################################################
# This module allows the creation of a AD Application
##############################################################

terraform {
  required_version = "~> 1.1.1"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.13.0"
    }
  }
}
