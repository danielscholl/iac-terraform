##############################################################
# This module defines the required versions
##############################################################

provider "azurerm" {
  version = "=2.16.0"
  features {}
}

provider "null" {
  version = "~>2.1.2"
}

provider "random" {
  version = "~>2.2.1"
}

provider "azuread" {
  version = "=0.10.0"
}
