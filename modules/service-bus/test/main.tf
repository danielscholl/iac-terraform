provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "service_bus" {
  source              = "../"
  name                = "iac-terraform-servicebus-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  topics = [
    {
      name                = "terraform-topic"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "iac"
          rights = ["listen", "send"]
        }
      ]
    }
  ]

  queues = [
    {
      name = "terraform-queue"
      authorization_rules = [
        {
          name   = "iac"
          rights = ["listen", "send"]
        }
      ]
    }
  ]

  resource_tags = {
    iac = "terraform"
  }
}