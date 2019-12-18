module "resource-group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "keyvault" {
  source              = "github.com/danielscholl/iac-terraform/modules/keyvault"
  name                = "iac-terraform-kv-${module.resource-group.random}"
  resource_group_name = module.resource-group.name
}

module "keyvault-secret" {
  source               = "../"
  keyvault_id          = module.keyvault.id
  secrets              = {
    "iac": "terraform"
  }
}