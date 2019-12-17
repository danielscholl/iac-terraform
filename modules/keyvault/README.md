# Module keyvault

A terraform module that provisions key vaults in Azure with the following characteristics:

- Provisions key vaults in the specified resource group.

- Access policy permissions for the deployment's service principal are configurable: `key_permissions`, `secret_permissions` and `certificate_permissions`.

- Allows for IP and Subnet Whitelisting for access restrictions.

## Usage

### Basic

```
resource "azurerm_resource_group" "example" {
  name     = "my-resourcegroup"
  location = "eastus2"
}

module "keyvault" {
  # Module Path
  source = "github.com/danielscholl/iac-terraform/tree/master/modules/keyvault"

  # Module variable
  name           = "mykeyvault"
  resource_group = azurerm_resource_group.example.name
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| name                          | _(Required)_                         | The name of the web app..        |
| resource_group_name           | _(Required)_                         | The name of an existing resource group. |
| resource_tags                 | _(Optional)_                         | Map of tags to apply to taggable resources in this module. |
| sku                           | standard                             |
| key_permissions               | ["create", "delete", "get"]          |
| secret_permissions            | ["set", "delete", "get", "list"]     |
| certificate_permissions       | ["create", "delete", "get", "list"]  |
| subnet_id_whitelist           | _(Optional)_                         |
| resource_ip_whitelist         | _(Optional)_                         |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The id of the Keyvault.
- `uri`: The uri of the keyvault.
- `name`: The name of the Keyvault.
