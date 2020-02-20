##############################################################
# This module defines the required versions
##############################################################

provider "azurerm" {
  azurerm = "~> 1.44"
}

provider "null" {
  version = "~>2.1.0"
}

provider "azuread" {
  version = "~>0.7.0"
}
