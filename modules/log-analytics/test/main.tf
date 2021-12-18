provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "log_analytics" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-logs-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  solutions = [
    {
      solution_name = "ContainerInsights",
      publisher     = "Microsoft",
      product       = "OMSGallery/ContainerInsights",
    }
  ]

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
