# Module service-plan

A terraform module that provisions and scales an app service plan with the following characteristics: 

- Ability to specify resource group name in which the App Service Plan is deployed.
- Ability to specify resource group location in which the App Service Plan is deployed.
- Also gives ability to specify following settings for App Service Plan based on the requirements:
  - kind : The kind of the App Service Plan to create.
  - tags : A mapping of tags to assign to the resource.
  - reserved : Is this App Service Plan Reserved.
  - tier : Specifies the plan's pricing tier.
  - size : Specifies the plan's instance size.
  - capacity : Specifies the number of workers associated with this App Service Plan.

Please click the [link](https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#capacity) to get additional details on settings in Terraform for Azure App Service Plan.

## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "service_plan" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
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
| `kind`                            | _string_   | The kind of service plan to be created. Possible values are Windows/Linux/FunctionApp/App. Default: `Linux` |
| `tier`                            | _string_   | The tier under which the service plan is created. Default: `Standard` |
| `size`                            | _string_   | The compute and storage needed for the service plan to be deployed. Default: `S1`|
| `capacity`                        | _int_      | The capacity of Service Plan to be created. Default: `1` |
| `isReserved`                      | _bool_     | Is the Service Plan to be created reserved. Possible values are true/false Default: `true` |
| `app_service_environment_id`      | _string_   | If specified, the ID of the App Service Environment where this plan should be deployed |
| `autoscale_capacity_minimum`      | _int_      | The minimum number of instances for this resource. Valid values are between 0 and 1000 Default: `1` |
| `scaling_rules`                   | __object__ | The scaling rules for the app service plan. |


The __scaling_rules__ object
```
{
      metric_trigger = {
        metric_name      = "CpuPercentage"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 70
      }
      scale_action = {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT10M"
      }
      }, {
      metric_trigger = {
        metric_name      = "CpuPercentage"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = 25
      }
      scale_action = {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
    }
```

## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `name`: The URL of the service plan created
- `id`: The resource id of the service plan created
