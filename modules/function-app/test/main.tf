provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "storage_account" {
  source              = "../../storage-account"
  resource_group_name = module.resource_group.name
  name                = substr("iacterraform${module.resource_group.random}", 0, 23)
  containers = [
    {
      name        = "function-releases",
      access_type = "private"
    }
  ]
}

module "service_plan" {
  source              = "../../service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  // Container Based Function Apps must be Premium Plan  :-(
  tier = "PremiumV2"
  size = "P1v2"

  resource_tags = {
    iac = "terraform"
  }
}

module "function_app" {
  source               = "../"
  name                 = "iac-terraform-func-${module.resource_group.random}"
  resource_group_name  = module.resource_group.name
  storage_account_name = module.storage_account.name
  service_plan_name    = module.service_plan.name

  function_app_config = {
    func1 = {
      image = "danielscholl/spring-function-app:latest",
      app_settings = {
        "FUNCTIONS_WORKER_RUNTIME"            = "java"
        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
      }
    }
  }

  resource_tags = {
    iac = "terraform"
  }
}