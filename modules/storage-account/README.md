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

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->