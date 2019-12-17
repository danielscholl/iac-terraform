# Module Azure Resource Group

Module for creating and managing Azure Resource Groups.

## Usage

```hcl
module "resource-group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name          = "test-resourcegroup"
  location      = "test-azure-region"
  tags          = {
    environment = "test-environment"
  } 
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| name                          | _(Required)_                         | The name of the resource group.      |
| location                      | _(Required)_                         | The location of the resource group.  |
| resource_tags                 | _(Optional)_                         | Map of tags to apply to taggable resources in this module. |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

```
Outputs:

name = <resourcegroupname>
location = <resourcegrouplocation>
id = <resourcegroupid>
random = <resourcegrouprandom>
```
