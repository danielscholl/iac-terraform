module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "storage_account" {
  source              = "../"
  resource_group_name = module.resource_group.name
  name                = substr("iacterraform${module.resource_group.random}", 0, 23)
  containers = [
    {
      name        = "iac-container",
      access_type = "private"
    }
  ]
  encryption_source = "Microsoft.Storage"
}