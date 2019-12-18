# Module keyvault

A terraform module that manage key vault permissions and policies for a specified list of resource identifiers in Azure with the following characteristics:

- Creates new key vault access policy(s) for a specified set of azure resources: `[object_ids]`, `tenant_id`.

- Access policy permissions are configurable: `keyvault_key_permissions`, `keyvault_secret_permissions` and `keyvault_certificate_permissions`.

## Usage


```
module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "service_plan" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-plan"
  name                = "iac-terraform-plan-${module.resource-group.random}"
  resource_group_name = module.resource_group.name
}

module "app_service" {
  source                     = "github.com/danielscholl/iac-terraform/modules/app-service"
  name                       = "iac-terraform-web-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  docker_registry_server_url = "mcr.microsoft.com"

  app_service_config = {
     web = {
        image = "azuredocs/aci-helloworld:latest"
     }
  }
}

module "keyvault" {
  source              = "github.com/danielscholl/iac-terraform/modules/keyvault"
  name                = "iac-terraform-kv-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}

module "keyvault_policy" {
  source                  = "github.com/danielscholl/iac-terraform/modules/keyvault-policy"
  vault_id                = module.keyvault.id
  tenant_id               = module.app_service.identity_tenant_id
  object_ids              = module.app_service.identity_object_ids
  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
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
