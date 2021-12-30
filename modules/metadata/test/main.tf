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
  source = "../../naming"
}

module "metadata" {
  source = "../"

  naming_rules = module.naming.yaml

  market              = "us"
  project             = "https://github.com/danielscholl/iac-terraform"
  location            = "eastus2"
  environment         = "sandbox"
  product_name        = "contosoweb"
  business_unit       = "infra"
  product_group       = "contoso"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "dev"
  resource_group_type = "app"

  additional_tags = {
    "support_email" = "support@contoso.com"
    "owner"         = "Jon Doe"
  }
}

output "names" {
  value = module.metadata.names
}

output "tags" {
  value = module.metadata.tags
}
