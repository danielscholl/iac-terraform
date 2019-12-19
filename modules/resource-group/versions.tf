##############################################################
# This module allows the creation of a Resource Group
##############################################################

terraform {
  required_version = "~> 0.12.17"
  required_providers {
    azurerm = "~> 1.37"
    random  = "~> 2.2"
  }
}
