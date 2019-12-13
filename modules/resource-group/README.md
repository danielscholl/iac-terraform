# Module Azure Resource Group

Simple Module for creating and managing Azure Resource Groups.

## Usage

### Module Definitions

- Resource Group Module        : iac/modules/providers/azure/resource-group

```
module "resourcegroup" {
  source                      = "github.com/danielscholl/spring-api-user/iac/modules/providers/azure/resource-group"
  resource_group_name         = "test-resourcegroup"
  location                    = "test-azure-region"
  environment                 = "test-environment"
}
```

## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

```
Outputs:

resource_group_name = <resourcegroupname>
resource_group_location = <resourcegrouplocation>
resource_group_id = <resourcegroupid>
resource_group_random = <resourcegrouprandom>
```
