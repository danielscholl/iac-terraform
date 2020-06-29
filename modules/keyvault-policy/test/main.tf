provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "service_plan" {
  source              = "../../service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}

module "app_service" {
  source                     = "../../app-service"
  name                       = "iac-terraform-web-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  docker_registry_server_url = "mcr.microsoft.com"

  app_service_config = {
    web = {
      image = "azuredocs/aci-helloworld:latest"
    }
  }
}

module "keyvault" {
  source              = "../../keyvault"
  name                = substr("iac-terraform-kv-${module.resource_group.random}", 0, 23)
  resource_group_name = module.resource_group.name
}

module "keyvault_policy" {
  source                  = "../"
  vault_id                = module.keyvault.id
  tenant_id               = module.app_service.identity_tenant_ids[0]
  object_ids              = module.app_service.identity_object_ids
  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
}
