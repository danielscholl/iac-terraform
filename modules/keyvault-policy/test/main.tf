resource "azurerm_resource_group" "example" {
  name     = "iac-terraform"
  location = "eastus2"
}

resource "random_id" "example" {
  keepers = {
    resource_group = azurerm_resource_group.example.name
  }
  byte_length = 3
}

module "service_plan" {
  source              = "../../service-plan"
  name                = "iac-terraform-plan-${random_id.example.hex}"
  resource_group_name = azurerm_resource_group.example.name
}

module "app_service" {
  source                     = "../../app-service"
  name                       = "iac-terraform-web-${random_id.example.hex}"
  resource_group_name        = azurerm_resource_group.example.name
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
  name                = "iac-terraform-kv-${random_id.example.hex}"
  resource_group_name = azurerm_resource_group.example.name
}

module "keyvault-policy" {
  source                  = "../"
  vault_id                = module.keyvault.id
  tenant_id               = module.app_service.identity_tenant_id
  object_ids              = module.app_service.identity_object_ids
  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
}
