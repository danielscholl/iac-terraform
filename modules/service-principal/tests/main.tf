provider "azurerm" {
  features {}
}

provider "azuread" {

}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "service_principal" {
  source = "../"

  name     = format("iac-terraform-%s", module.resource_group.random)
  role     = "Contributor"
  scopes   = [module.resource_group.id]
  end_date = "1W"

  api_permissions = [
    {
      name = "Microsoft Graph"
      app_roles = [
        "Directory.Read.All"
      ]
    }
  ]
}