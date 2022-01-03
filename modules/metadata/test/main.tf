terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.32.0"
    }
  }
  required_version = ">=1.1.1"
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "subscription" {
  source          = "../../subscription-data"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

module "naming" {
  source = "../../naming-rules"
}

module "metadata" {
  source = "../"

  naming_rules = module.naming.yaml
  
  location            = "eastus2"
  environment         = "sandbox"
  product             = "engineering"

  additional_tags = {
    "repo"         = "https://github.com/danielscholl/iac-terraform"
    "owner"         = "Daniel Scholl"
  }
}

output "names" {
  value = module.metadata.names
}

output "tags" {
  value = module.metadata.tags
}
