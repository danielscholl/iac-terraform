module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "cosmosdb" {
  source                   = "../"
  name                     = "iac-terraform-db-${module.resource_group.random}"
  resource_group_name      = module.resource_group.name
  kind                     = "GlobalDocumentDB"
  automatic_failover       = false
  consistency_level        = "Session"
  primary_replica_location = module.resource_group.location
  database_name            = "iac-terraform-database"
  container_name           = "iac-terraform-container"
}