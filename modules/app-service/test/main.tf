provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

# module "ad_application" {
#   source = "github.com/danielscholl/iac-terraform/modules/ad-application"

#   name = "iac-terraform-ad-app"
#   group_membership_claims = "All"

#   reply_urls = [
#     "https://localhost:8080",
#     "https://localhost:8080/.auth/login/aad/callback"
#   ]

#   api_permissions = [
#     {
#       name = "Microsoft Graph"
#       oauth2_permissions = [ "User.Read" ]
#       app_roles = [ ]
#     }
#   ]
# }

module "service_plan" {
  source              = "../../service-plan"
  name                = "iac-terraform-plan-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
}

module "app_service" {
  source                     = "../"
  name                       = "iac-terraform-web-${module.resource_group.random}"
  resource_group_name        = module.resource_group.name
  service_plan_name          = module.service_plan.name
  docker_registry_server_url = "mcr.microsoft.com"
  instrumentation_key        = "secret_key"

  app_settings = {
    iac = "terraform"
  }

  app_service_config = {
    web = {
      image = "azuredocs/aci-helloworld:latest"
    }
  }

  # auth = {
  #   enabled = true
  #   active_directory = {
  #     client_id     = module.ad_application.id
  #     client_secret = module.ad_application.password
  #   }
  # }

  resource_tags = {
    iac = "terraform"
  }
}
