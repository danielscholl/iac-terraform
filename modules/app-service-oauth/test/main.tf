data "azurerm_client_config" "current" {}

locals {
  tenantId = data.azurerm_client_config.current.tenantId
}

module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "service_plan" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}

module "app_service" {
  source                     = "../"
  name                       = "iac-terraform-web-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  docker_registry_server_url = "mcr.microsoft.com"
  instrumentation_key        = "secret_key"

  app_settings = {
    iac = "terraform"
  }

  app_service_config = {
    web = {
      image = "azuredocs/aci-helloworld:latest"
    }
  }

  auth_settings = {
    enabled = false
    active_directory = {
      client_id     = ""
      client_secret = ""
    }
    token_store_enabled = true
  }

  

  resource_tags = {
    iac = "terraform"
  }
}
