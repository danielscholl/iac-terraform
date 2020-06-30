# Module storage-account

A terraform module that provisions and scales an storage account with the following characteristics: 

- Ability to enrolls storage account into azure 'managed identities' authentication.
- Create multiple containers with access levels.


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "storage_account" {
  source                    = "github.com/danielscholl/iac-terraform/modules/storage-account"
  resource_group_name       = module.resource_group.name
  name                      = substr("iacterraform${module.resource_group.random}", 0, 23)
  containers = [
    {
      name  = "iac-container",
      access_type = "private"
    }
  ]
}
```

## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the web app service.     |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `kind`                            | _string_   | The type of the Storage Account. Default: `StorageV2` |
| `tier`                            | _string_   | The performance level of the Storage Account. |
| `replication_type`                | _string_   | The type of replication for the Storage Account. Default: `LRS` |
| `ensure_https`                    | _bool_     | Boolean flag which forces HTTPS in order to ensure secure connections. |
| `containers`                      | _object_   | List of storage containers. |
| `assign_identity`                 | _bool_     | Enable system-assigned managed identity. Default: `true` |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The storage account Id.
- `name`: The name of the storage account.
- `primary_connection_string`: The primary connection string for the storage account.
- `primary_access_key`: The primary access key for the storage account.
- `tenant_id`: The tenant ID for the Service Principal of this storage account.
- `managed_identities_id`: The principal ID generated from enabling a Managed Identity with this storage account.
- `containers`: Map of containers.
