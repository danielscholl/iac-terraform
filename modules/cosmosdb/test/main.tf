provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}


module "cosmosdb_sql" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-sql-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  kind                     = "GlobalDocumentDB"
  automatic_failover       = true
  consistency_level        = "Session"
  primary_replica_location = module.resource_group.location

  databases = [
    {
      name       = "iac-terraform-database"
      throughput = 4000 # This is max throughput Minimum level is 4000
    }
  ]
  sql_collections = [
    {
      name                  = "iac-terraform-container1"
      database_name         = "iac-terraform-database"
      partition_key_path    = "/id"
      partition_key_version = null

    },
    {
      name                  = "iac-terraform-container2"
      database_name         = "iac-terraform-database"
      partition_key_path    = "/id"
      partition_key_version = null
    }
  ]

  resource_tags = {
    source = "terraform",
  }
}

module "cosmosdb_graph" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "iac-terraform-graph-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  kind                     = "GlobalDocumentDB"
  automatic_failover       = true
  consistency_level        = "Session"
  primary_replica_location = module.resource_group.location

  graph_databases = [
    {
      name       = "iac-terraform-database"
      throughput = 4000 # This is max throughput Minimum level is 4000
    }
  ]

  graphs = [
    {
      name               = "iac-terraform-graph1"
      database_name      = "iac-terraform-database"
      partition_key_path = "/mypartition"
    },
    {
      name               = "iac-terraform-graph2"
      database_name      = "iac-terraform-database"
      partition_key_path = "/mypartition"
    }
  ]

  resource_tags = {
    source = "terraform",
  }
}
