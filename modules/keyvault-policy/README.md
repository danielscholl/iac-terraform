# Module keyvault

A terraform module that manage key vault permissions and policies for a specified list of resource identifiers in Azure with the following characteristics:

- Creates new key vault access policy(s) for a specified set of azure resources: `[object_ids]`, `tenant_id`.

- Access policy permissions are configurable: `keyvault_key_permissions`, `keyvault_secret_permissions` and `keyvault_certificate_permissions`.

## Usage

### Basic

```
resource "azurerm_resource_group" "example" {
  name     = "my-resourcegroup"
  location = "eastus2"
}

module "keyvault" {
  # Module Path
  source = "github.com/danielscholl/iac-terraform/modules/keyvault-policy"

  # Module variable
  vault_id            = "${module.keyvault_certificate.vault_id}"
  tenant_id           = "${module.app_service.app_service_identity_tenant_id}"
  object_ids          = "${module.app_service.app_service_identity_object_ids}"
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| vault_id                      | _(Required)_                         | Specifies the name of the Key Vault. |
| tenant_id                     | _(Required)_                         | The tenant ID used for authenticating. |
| object_ids                    | _(Required)_                         | The object IDs used for authenticating. |
| key_permissions               | ["create", "delete", "get", "list"]  | List of key permissions.             |
| secret_permissions            | ["delete", "get", "set", "list"]     | List of secret permissions.          |
| certificate_permissions       | ["create", "delete", "get", "list"]  | List of certificate permissions.     |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:


