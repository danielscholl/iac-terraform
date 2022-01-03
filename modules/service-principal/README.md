# Module service-principal

Module for managing a service principal for Azure Active Directory with the following characteristics:

- Create a Principal and Assign to a role or use an existing principal.

> __This module requires the Terraform Principal to have Azure Active Directory Graph - `Application.ReadWrite.OwnedBy` Permissions.__


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

module "service_principal" {
  source = "github.com/danielscholl/iac-terraform/modules/service-principal"

  name = format("iac-terraform-%s", module.resource_group.random)
  role = "Contributor"
  scopes = [module.resource_group.id]
  end_date = "1W"
}
```

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->