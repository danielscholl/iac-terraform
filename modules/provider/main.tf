##############################################################
# This module defines the required versions
##############################################################

provider "azurerm" {
  version = "=2.7.0"
  features {}
}

provider "null" {
  version = "~>2.1.0"
}

provider "random" {
  version = "~>2.2"
}

provider "azuread" {
  version = "=0.7.0"
}
