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
  source              = "github.com/danielscholl/iac-terraform/modules/service_plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| name                          | _(Required)_                         | The name of the service plan.        |
| resource_group_name           | _(Required)_                         | The name of an existing resource group. |
| resource_tags                 | _(Optional)_                         | Map of tags to apply to taggable resources in this module. |
| kind                          | Linux                                | The kind of service plan to be created. Possible values are Windows/Linux/FunctionApp/App. |
| tier                          | Standard                             | The tier under which the service plan is created. |
| size                          | S1                                   | The compute and storage needed for the service plan to be deployed. |
| capacity                      | 1                                    | The capacity of Service Plan to be created. |
| isReserved                    | true                                 | Is the Service Plan to be created reserved. Possible values are true/false |
| app_service_environment_id    | _(Optional)_                         | If specified, the ID of the App Service Environment where this plan should be deployed |
| autoscale_capacity_minimum    | 1                                    | The minimum number of instances for this resource. Valid values are between 0 and 1000 |
| scaling_rules                 | _*See Note_                       | The scaling rules for the app service plan. |

> __scaling_rules__
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

```
Outputs:

name = my-resourcegroup-plan
id = <resource_id>
```

### Attributes Reference

The following attributes are exported:

- `name`: The URL of the service plan created
- `ids`: The resource id of the service plan created
