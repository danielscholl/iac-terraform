# Module app-service

A terraform module that provisions and scales azure managed app service using Linux-based containers with the following characteristics: 

- Provisions multiple app service web apps with linux containers through the `app_service_name` `map(string)`. The key resolves to the name of the app service resource while the value is the source image for the resource. One app service resource(s) per mapped entry is provisioned.

- Canary deployments through an auto-provisioned staging slot.



## Usage

### Basic

```
resource "azurerm_resource_group" "example" {
  name     = "my-resourcegroup"
  location = "eastus2"
}

resource "azurerm_app_service_plan" "example" {
  name                = "my-resourcegroup-plan"
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
  source = "github.com/danielscholl/iac-terraform/modules/app-service"

  name                       = "sampleapp"
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_name          = azurerm_app_service_plan.example.name
  docker_registry_server_url = "mcr.microsoft.com"
  app_service_config = {
     web = {
        image = "azuredocs/aci-helloworld:latest"
     }
  }
}
```

### Advanced

```
resource "azurerm_resource_group" "example" {
  name     = "my-resourcegroup"
  location = "eastus2"
}

resource "azurerm_app_service_plan" "example" {
  name                = "my-resourcegroup-plan"
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
  # Module Path
  source = "github.com/danielscholl/iac-terraform/tree/master/modules/app-service"

  # Module Variables
  name                       = "sampleapp"
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_name          = azurerm_app_service_plan.example.name
  docker_registry_server_url = "mcr.microsoft.com"
  app_service_config = {
     web = {
        image = "azuredocs/aci-helloworld:latest"
     }
  }
  vault_uri                  = azurerm_key_vault.example.id
  cosmosdb_name              = azurerm_cosmosdb_account.example.name
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| name                          | _(Required)_                         | The name of the web app..        |
| resource_group_name           | _(Required)_                         | The name of an existing resource group. |
| resource_tags                 | _(Optional)_                         | Map of tags to apply to taggable resources in this module. |
| service_plan_name             | _(Required)_                         | The name of the service plan. |
| app_service_config            | _*See Note_                          | Metadata about the app services to be created. |
| app_settings                  | _(Optional)_                         | Custom App Web App Settings. |
| resource_tags                 | _(Optional)_                         | Map of tags to apply to taggable resources in this module. |
| vault_uri                     | _(Optional)_                         | Specifies the URI of the Key Vault resource. |
| instrumentation_key           | _(Optional)_                         | The Instrumentation Key for the Application Insights component. |
| is_always_on                  | true                                 | Is the app is loaded at all times. |
| docker_registry_server_url    | docker.io                            | The docker registry server URL for images. |
| docker_registry_server_username | _(Optional)_                       | The docker registry server username for images. |
| docker_registry_server_password | _(Optional)_                       | The docker register server password for images. |
| cosmosdb_name                 | _(Optional)_                         | The comsosdb account name. If submited will apply cosmos values to app settings. |
| is_db_enabled                 | true                                 | Is the app using cosmosdb. |
| is_vnet_isolated              | false                                | Is VNet restriction enabled. |
| vnet_name                     | _(Optional)_                         | The integrated VNet name. |
| vnet_subnet_id                | _(Optional)_                         | The VNet integration subnet gateway identifier. |


The app_service_config object accepts the following keys:

> __app_service_config__
```
The app_service_config object produces an instance of a web app with the desired container image.

{
  web1 = { image = "azuredocs/aci-helloworld:latest" },
  web2 = { image = "azuredocs/aci-helloworld:latest" }
}
```

## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `uris`: The URL of the app service created
- `ids`: The resource ids of the app service created
- `identity_tenant_id`: The Tenant ID for the Service Principal associated with the Managed Service Identity of this App Service
- `identity_object_ids`: The Principal IDs for the Service Principal associated with the Managed Service Identity for all App Services

