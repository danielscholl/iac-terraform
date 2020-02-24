##############################################################
# This module allows the creation of a Resource Group
##############################################################

terraform {
  required_version = "~> 0.12.20"
  required_providers {
    random  = "~> 2.2"
    azurerm = "~> 1.44"
  }
}
