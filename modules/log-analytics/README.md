# Module Azure Log Analytics

Module for creating and managing a Log Analytics Workspace.

## Usage

```
module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "log_analytics" {
  source = "../"

  name                = "iac-terraform-logs-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  solutions = [
    {
        solution_name = "ContainerInsights",
        publisher = "Microsoft",
        product = "OMSGallery/ContainerInsights",
    }
  ]

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
```

### Input Variables

Please refer to [variables.tf](./variables.tf).

### Output Variables

Please refer to [output.tf](./output.tf).

