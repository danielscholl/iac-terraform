# Module cosmosdb

A terraform module that provides a Cosmos DB with the following characteristics:

- Provisions a cosmosdb (sql) instance in the specified resource group using the location of the resource group.

- Provisions a Database and Container if provided


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "cosmosdb" {
  source                    = "github.com/danielscholl/iac-terraform/modules/cosmosdb"
  name                      = "iac-terraform-db-${module.resource_group.random}"
  resource_group_name       = module.resource_group.name
  kind                      = "GlobalDocumentDB"
  automatic_failover        = false
  consistency_level         = "Session"
  primary_replica_location  = module.resource_group.location
  databases                = [
    {
      name       = "iac-terraform-database"
      throughput = 400
    }
  ]
  sql_collections          = [
    {
      name               = "iac-terraform-container"
      database_name      = "iac-terraform-database"
      partition_key_path = "/id"
      throughput         = 400
    }
  ]
}
```

## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the web app service.     |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `kind`                            | _string_   | Determines the kind of CosmosDB to create. Default: `GlobalDocumentDB` |
| `automatic_failover`              | _bool_     | Determines if automatic failover is enabled. Default: `true` |
| `consitency_level`                | _string_   | The consistancy level to use. Default: `true`       |
| `primary_replica_location`        | _string_   | The location to host replicated data.|
| `databases`                       | __Object__   | The list of the cosmosdb databases.   |
| `sql_collections`                 | __Object__   | The lsit of the cosmosdb containers.  |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `endpoint`: The endpoint used to connect to the CosmosDB account.
- `name`: The ComosDB Account Name.
- `primary_master_key`: The Primary master key for the CosmosDB Account.
- `connection_strings`: A list of connection strings available for this CosmosDB account.

