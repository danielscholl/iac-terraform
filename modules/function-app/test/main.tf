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
      name  = "function-releases",
      access_type = "private"
    }
  ]
  encryption_source         = "Microsoft.Storage"
}

module "service_plan" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  resource_tags = {
    iac = "terraform"
  }
}

module "function_app" {
  source                  = "../"
  name                    = "iac-terraform-func-${module.resource_group.random}"
  resource_group_name     = module.resource_group.name
  storage_account_name    = module.storage_account.name
  service_plan_name       = module.service_plan.name
  docker_registry_server_url = "mcr.microsoft.com"
  is_java = false

  function_app_config = {
     func1 = {
        image = "azure-functions/dotnet:2.0-appservice"
     }
  }

  resource_tags = {
    iac = "terraform"
  }
}