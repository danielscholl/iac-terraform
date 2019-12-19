# Module app-insights

A terraform module that provisions application insights with the following characteristics: 

- Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created.


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "app_insights" {
  source              = "github.com/danielscholl/iac-terraform/modules/app-insights"
  name                = "iac-terraform-insights-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

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
| `type`                            | _string_   | Type of the App Insights Application. Default: `java` |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The Application Insights Id.
- `instrumentation_key`: The Application Insights Instrumentation Key.

