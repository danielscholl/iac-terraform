module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "api-mgmt" {
  source                     = "../"

  name                       = "iac-terraform-apimgmt-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
  organization_name          = "iac-terraform"
  administrator_email        = "iac@terraform.com"
  tier                       = "Developer"
  capacity                   = 1
  
  resource_tags = {
    iac = "terraform"
  }
}