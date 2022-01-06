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
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.10 |
| azuread | >= 2.13.0 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | >= 2.13.0 |
| azurerm | n/a |
| random | 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_permissions | List of API permissions. | `any` | `[]` | no |
| create\_for\_rbac | Create a new Service Principle | `bool` | `true` | no |
| end\_date | The relative duration or RFC3339 date after which the password expire. | `string` | `"2Y"` | no |
| name | The name of the service principal. | `string` | n/a | yes |
| object\_id | Object Id of an existing service principle to be assigned to a role. | `string` | `""` | no |
| password | A password for the service principal. (Optional) | `string` | `""` | no |
| principal | Bring your own Principal metainformation. Optional: {name, appId, password} | `map(string)` | `{}` | no |
| role | The name of a role for the service principal. | `string` | `""` | no |
| scopes | List of scopes the role assignment applies to. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_id | The ID of the Azure AD Application |
| client\_secret | The password of the generated service principal. This is only exported when create\_for\_rbac is true. |
| id | The ID of the Azure AD Service Principal |
| name | The Display Name of the Azure AD Application associated with this Service Principal |

<!--- END_TF_DOCS --->