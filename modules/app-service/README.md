# Module app-service

A terraform module that provisions and scales azure managed app service using Linux-based containers with the following characteristics: 

- Provisions multiple app service web apps with linux containers through the `app_service_name` `map(string)`. The key resolves to the name of the app service resource while the value is the source image for the resource. One app service resource(s) per mapped entry is provisioned.

- Canary deployments through an auto-provisioned staging slot.



## Usage

```hcl
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
  source                     = "github.com/danielscholl/iac-terraform/modules/app-service"
  name                       = "iac-terraform-web-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
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
```


## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the web app service.     |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `service_plan_name`               | _string_   | The name of the app service plan.    |
| `app_service_config`              | __Object__ | Metadata about the app services to be created. |
| `app_settings`                    | _list_     | Custom App Web App Settings.       |
| `vault_uri`                       | _string_   | Specifies the URI of the Key Vault resource. |
| `instrumentation_key`             | _string_   | The Instrumentation Key for the Application Insights component. |
| `is_always_on`                    | _bool_     | Is the app is loaded at all times. Default: `true` |
| `docker_registry_server_url`      | _string_   | The docker registry server URL for images. Default: `docker.io`|
| `docker_registry_server_username` | _string_   | The docker registry server username for images. |
| `docker_registry_server_password` | _string_   | The docker register server password for images. |
| `is_vnet_isolated`                | _bool_     | Is VNet restriction enabled.  Default: `false`     |
| `vnet_name`                       | _string_   | The integrated VNet name.          |
| `vnet_subnet_id`                  | _string_   | The VNet integration subnet gateway identifier. |


The __app_service_config__ object accepts the following keys:

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

