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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.90.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_id.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment tag for the Resource Group. | `string` | `"dev"` | no |
| <a name="input_isLocked"></a> [isLocked](#input\_isLocked) | Does the Resource Group prevent deletion? | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the Resource Group. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Resource Group. | `string` | `null` | no |
| <a name="input_names"></a> [names](#input\_names) | Names to be applied to resources (inclusive) | <pre>object({<br>    environment = string<br>    location    = string<br>    product     = string<br>  })</pre> | <pre>{<br>  "environment": "sandbox",<br>  "location": "eastus2",<br>  "product": "iac"<br>}</pre> | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Map of tags to apply to taggable resources in this module.  By default the taggable resources are tagged with the name defined above and this map is merged in | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the Resource Group. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Resource Group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Resource Group. |
| <a name="output_random"></a> [random](#output\_random) | A random string derived from the Resource Group. |

<!--- END_TF_DOCS --->