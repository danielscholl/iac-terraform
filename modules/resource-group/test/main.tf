module "resource-group" {
  source = "../"

  name     = "iac-terraform"
  location = "eastus2"

  resource_tags          = {
    environment = "test-environment"
  } 
}