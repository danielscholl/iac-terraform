provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
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
  databases = [
    {
      name       = "iac-terraform-database1"
      throughput = 400
    },
    {
      name       = "iac-terraform-database2"
      throughput = 400
    }
  ]
  sql_collections = [
    {
      name               = "iac-terraform-container1"
      database_name      = "iac-terraform-database1"
      partition_key_path = "/id"
      throughput         = 400
    },
    {
      name               = "iac-terraform-container2"
      database_name      = "iac-terraform-database1"
      partition_key_path = "/id"
      throughput         = 400
    },
    {
      name               = "iac-terraform-container1"
      database_name      = "iac-terraform-database2"
      partition_key_path = "/id"
      throughput         = 400
    },
    {
      name               = "iac-terraform-container2"
      database_name      = "iac-terraform-database2"
      partition_key_path = "/id"
      throughput         = 400
    }
  ]
}

