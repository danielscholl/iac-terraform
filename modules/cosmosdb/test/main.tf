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

module "cosmosdb" {
  source                    = "../"

  name                       = "iac-terraform-db-${random_id.example.hex}"
  resource_group_name       = azurerm_resource_group.example.name
  kind                      = "GlobalDocumentDB"
  automatic_failover        = false
  consistency_level         = "Session"
  primary_replica_location  = azurerm_resource_group.example.location
  database_name             = "iac-terraform-database"
  container_name            = "iac-terraform-container"
}