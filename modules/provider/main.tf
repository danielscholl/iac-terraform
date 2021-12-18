##############################################################
# This module defines the required versions
##############################################################

provider "azurerm" {
  version = "=2.29.0"
  features {}
}

provider "null" {
  version = "~>3.1.0"
}

provider "random" {
  version = "~>3.1.0"
}

provider "azuread" {
  version = "=2.13.0"
}
