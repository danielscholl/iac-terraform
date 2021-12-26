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

  name            = format("iac-terraform-%s", module.resource_group.random)
  role            = "Contributor"
  scopes          = [module.resource_group.id]
  create_for_rbac = false
  #end_date = "1W"

  #api_permissions = [
  #  {
  #    name = "Microsoft Graph"
  #    app_roles = [
  #      "Directory.Read.All"
  #    ]
  #  }
  #]

  object_id = "a6737152-2e8c-4db6-996a-d85694845b6f"

  principal = {
    name     = "iac-terraform-87800d4ad95deb0c"
    appId    = "9a4cc2ab-63c5-45f7-a05a-002de7105e53"
    password = "apassword"
  }
}