module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "app_insights" {
  source              = "../"
  name                = "iac-terraform-insights-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }
}