# Module service-principal

Module for managing a service principal within Azure Active Directory.

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

## Inputs

| Variable Name | Type       | Description                          | 
| ------------- | ---------- | ------------------------------------ |
| `name`        | _string_   | The name of the service principal.     |
| `password`    | _string_   | A password for the service principal. (Optional).  |
| `end_date`    | _string_   | The relative duration or RFC3339 date after which the password expire.|
| `role`        | _string_   | The name of a role for the service principal. |
| `scopes`      | _list_     | List of scopes the role assignment applies to. |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `name`: The Service Principal Display Name.
- `object_id`: The Service Principal Object Id.
- `tenant_id`: The Service Principal Tenant Id.
- `client_id`: The Service Principal Client Id (Application Id)
- `client_secret`: The Service Principal Client Secret (Application Password).
