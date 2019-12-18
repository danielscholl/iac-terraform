# Module keyvault

A terraform module that provisions key vaults in Azure with the following characteristics:

- Provisions key vaults in the specified resource group.

- Access policy permissions for the deployment's service principal are configurable: `key_permissions`, `secret_permissions` and `certificate_permissions`.

- Allows for IP and Subnet Whitelisting for access restrictions.

## Usage

```
module "resource_group" {
  source  = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "keyvault" {
  source              = "github.com/danielscholl/iac-terraform/modules/keyvault"
  name                = "iac-terraform-kv-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}
```

## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the web app service.     |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `sku`                             | _string_   | SKU of the keyvault to create. Default: `standard` |
| `key_permissions`                 | _list_     | Permissions that the service principal has for accessing keys from keyvault. Default: `["create", "delete", "get"]` |
| `secret_permissions`              | _list_     | Permissions that the service principal has for accessing secrets from keyvault. Default: `["set", "delete", "get", "list"]` |
| `certificate_permissions`         | _list_     | Permissions that the service principal has for accessing certificates from keyvault. Default: `["create", "delete", "get", "list"]` |
| `subnet_id_whitelist`             | _list_     | If supplied this represents the subnet IDs that should be allowed to access this resource |
| `resource_ip_whitelist`           | _list_     | A list of IPs and/or IP ranges that should have access to the provisioned keyvault |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The id of the Keyvault.
- `uri`: The uri of the keyvault.
- `name`: The name of the Keyvault.
