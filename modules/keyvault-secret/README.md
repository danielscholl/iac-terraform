# Module keyvault-secret

A terraform module to provide Key Vaults secrets for existing Key Vaults in Azure with the following characteristics:

- Secrets have a name that identifies them in the URL/ID
- Secrets have a secret value that gets encrypted and protected by the key vault

## Usage

Key Vault secret usage example:

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "keyvault" {
  source              = "github.com/danielscholl/iac-terraform/modules/keyvault"
  name                = "iac-terraform-kv-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}

module "keyvault_secret" {
  source               = "github.com/danielscholl/iac-terraform/modules/keyvault-secret"
  keyvault_id          = module.keyvault.id
  secrets              = {
    "iac": "terraform"
  }
}
```

## Inputs

| Variable Name             | Type       | Description                          | 
| ------------------------- | ---------- | ------------------------------------ |
| `vault_id`                | _string_   | Id of the Key Vault to store the secret in. |
| `secrets`                 | _list_     | Key/value pair of keyvault secret names and corresponding secret value. |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `secrets`: A map of Key Vault Secrets. The Key/Value association is the KeyVault secret name and value.
- `keyvault_id`: The id of the Key Vault.
