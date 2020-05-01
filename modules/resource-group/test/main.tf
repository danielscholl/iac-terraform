provider "azurerm" {
  version = "=2.7.0"
  features {}
}

module "resource_group" {
  source = "../"

  name     = "iac-terraform"
  location = "eastus2"

  resource_tags = {
    environment = "test-environment"
  }
}