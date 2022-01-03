# Module Azure Resource Group

Module for creating and managing Azure Resource Groups.

## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"

  resource_tags          = {
    environment = "test-environment"
  } 
}
```

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->