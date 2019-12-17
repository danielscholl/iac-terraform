# Module Azure Cosmos DB

A terraform module that provides a Cosmos DB with the following characteristics:

- Provisions a cosmosdb (sql) instance in the specified resource group using the location of the resource group.

- Provisions a Database and Container if provided


## Usage

### Basic

```
resource "azurerm_resource_group" "example" {
  name     = "my-resourcegroup"
  location = "eastus2"
}

module "cosmosdb" {
  source                    = "github.com/danielscholl/iac-terraform/modules/cosmosdb"

  name                      = "test-cosmosdb-instance"
  resource_group_name       = azurerm_resource_group.example.name
  kind                      = "GlobalDocumentDB"
  automatic_failover        = false
  consistency_level         = "Session"
  primary_replica_location  = azurerm_resource_group.example.location
  database_name             = "test-cosmosdb-database"
  container_name            = "test-cosmosdb-container"
}
```

## Inputs

| Variable                      | Default                              | Description                          | 
| ----------------------------- | ------------------------------------ | ------------------------------------ |
| name                          | _(Required)_                         | The name of the cosmosdb account.    |
| resource_group_name           | _(Required)_                         | The name of an existing resource group. |
| kind                          | GlobalDocumentDB                     | Determines the kind of CosmosDB to create. |
| automatic_failover            | false                                | Determines if automatic failover is enabled. |
| consitency_level              | Session                              | The consistancy level to use.        |
| primary_replica_location      | _(Required)_                         | The location to host replicated data.|
| database_name                 | _(Optional)_                         | The name of the cosmosdb database.   |
| container_name                | _(Optional)_                         | The name of the cosmosdb container.  |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `endpoint`: The endpoint used to connect to the CosmosDB account.
- `name`: The ComosDB Account Name.
- `primary_master_key`: The Primary master key for the CosmosDB Account.
- `connection_strings`: A list of connection strings available for this CosmosDB account.

