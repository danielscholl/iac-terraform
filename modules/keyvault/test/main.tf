resource "azurerm_resource_group" "example" {
  name     = "iac-terraform"
  location = "eastus2"
}

resource "random_id" "example" {
  keepers = {
    resource_group = azurerm_resource_group.example.name
  }
  byte_length = 3
}

module "keyvault" {
  # Module Path
  source = "../"

  # Module variable
  name                       = "iac-terraform-kv-${random_id.example.hex}"
  resource_group_name = azurerm_resource_group.example.name
}