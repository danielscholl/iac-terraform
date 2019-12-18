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

resource "azurerm_app_service_plan" "example" {
  name                = "iac-terraform-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind = "linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

module "app_service" {
  source                     = "../"
  name                       = "iac-terraform-web-${random_id.example.hex}"
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_name          = azurerm_app_service_plan.example.name
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

  resource_tags = {
    iac = "terraform"
  }
}
