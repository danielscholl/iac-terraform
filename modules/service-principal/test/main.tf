module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "service_principal" {
  source = "../"

  name = format("iac-terraform-%s", module.resource_group.random)
  role = "Contributor"
  scopes = [module.resource_group.id]
  end_date = "1W"
}