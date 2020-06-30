# Module container-registry

A terraform module that provisions and a docker container registry with the following characteristics: 

- Ability to enable Admin Level Access.
- Ability to restrict access to subnet segments.


## Usage

```
module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "container_registry" {
  source              = "../"
  name                = substr("iacterraform${module.resource_group.random}", 0, 23)
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }
}
```

## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the container registry.  |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `sku`                             | _string_   | The SKU name of the the container registry. Default: `Standard` |
| `is_admin_enabled`                | _bool_     | Boolean flag which enables admin level access. |
| `subnet_id_whitelist`             | _list_     | Represents the subnet IDs that should be allowed to access this resource. _(optional)_ |
| `resource_ip_whitelist`             | _list_     | A list of IPs and/or IP ranges that should have access to the provisioned container registry. _(optional)_ |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The container registry Id.
- `name`: The name of the container registry.
- `url`: The URL that can be used to log into the container registry.
- `admin_username`: If admin access is enabled, this will be the username for the ACR.
- `admin_password`: If admin access is enabled, this will be the password for the ACR.
