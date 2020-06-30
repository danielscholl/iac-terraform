# Module function-app

A terraform module that provisions and scales azure function apps using Linux-based containers with the following characteristics: 

- Provisions multiple function apps with linux containers through the `function_app_name` `map(string)`. The key resolves to the name of the app service resource while the value is the source image for the resource. One app service resource(s) per mapped entry is provisioned.


## Usage

```hcl
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "storage_account" {
  source                    = "github.com/danielscholl/iac-terraform/modules/storage-account"
  resource_group_name       = module.resource_group.name
  name                      = substr("iacterraform${module.resource_group.random}", 0, 23)
  containers = [
    {
      name  = "function-releases",
      access_type = "private"
    }
  ]
}

module "service_plan" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  // Container Based Function Apps must be Premium Plan  :-(
  tier                = "PremiumV2"
  size                = "P1v2"

  resource_tags = {
    iac = "terraform"
  }
}

module "function_app" {
  source                  = "../"
  name                    = "iac-terraform-func-${module.resource_group.random}"
  resource_group_name     = module.resource_group.name
  storage_account_name    = module.storage_account.name
  service_plan_name       = module.service_plan.name

  function_app_config = {
     func1 = {
        image = "danielscholl/spring-function-app:latest",
        app_settings = { 
          "FUNCTIONS_WORKER_RUNTIME"    = "java"
          "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
        }
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
| `name`                            | _string_   | The name of the function app.        |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `service_plan_name`               | _string_   | The name of the app service plan.    |
| `storage_account_name`            | _string_   | The name of the storage account.     |
| `function_app_config`             | __Object__ | Metadata about the function apps to be created. |
| `app_settings`                    | _list_     | Custom App Web App Settings.       |
| `instrumentation_key`             | _string_   | The Instrumentation Key for the Application Insights component. |
| `is_always_on`                    | _bool_     | Is the app is loaded at all times. Default: `true` |
| `docker_registry_server_url`      | _string_   | The docker registry server URL for images. Default: `docker.io`|
| `docker_registry_server_username` | _string_   | The docker registry server username for images. |
| `docker_registry_server_password` | _string_   | The docker register server password for images. |
| `app_settings`                    | __Object__ |Application settings to insert on creating the app. |            


The __function_app_config__ object accepts the following keys:

```
The function_app_config object produces an instance of a function app with the desired container image and settings.

{
  func1 = { image = "azure-functions/dotnet:2.0-appservice", app_settings = { "Hello" = "World" } }
}

```

## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `uris`: The URL of the function app created
- `ids`: The resource ids of the function app created
- `identity_tenant_id`: The Tenant ID for the Service Principal associated with the Managed Service Identity of this Function App
- `identity_object_ids`: The Principal IDs for the Service Principal associated with the Managed Service Identity for all Function Apps
