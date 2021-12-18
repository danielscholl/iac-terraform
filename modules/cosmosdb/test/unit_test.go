package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "cosmosdb-"
var location = "eastus"
var count = 12

var tfOptions = &terraform.Options{
	TerraformDir: "./",
	Upgrade:      true,
}

func asMap(t *testing.T, jsonString string) map[string]interface{} {
	var theMap map[string]interface{}
	if err := json.Unmarshal([]byte(jsonString), &theMap); err != nil {
		t.Fatal(err)
	}
	return theMap
}

func TestTemplate(t *testing.T) {

	expectedSqlAccountResult := asMap(t, `{
    "kind": "GlobalDocumentDB",
    "enable_automatic_failover": true,
    "enable_multiple_write_locations": false,
    "is_virtual_network_filter_enabled": false,
		"offer_type": "Standard",
    "consistency_policy": [{
      "consistency_level": "Session"
    }]
  }`)

	expectedGraphAccountResult := asMap(t, `{
    "kind": "GlobalDocumentDB",
    "enable_automatic_failover": true,
    "enable_multiple_write_locations": false,
    "is_virtual_network_filter_enabled": false,
		"offer_type": "Standard",
    "consistency_policy": [{
      "consistency_level": "Session"
    }],
    "capabilities": [{
      "name": "EnableGremlin"
    }]
	}`)

	expectedDatabaseResult := asMap(t, `{
		"name": "iac-terraform-database",
		"autoscale_settings": [{
      "max_throughput": 4000
    }]
	}`)

	expectedContainerResult := asMap(t, `{
    "database_name": "iac-terraform-database",
    "name": "iac-terraform-container1",
    "partition_key_path": "/id"
  }`)

	expectedGraphResult := asMap(t, `{
    "database_name": "iac-terraform-database",
    "name": "iac-terraform-graph1",
    "partition_key_path": "/mypartition"
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.cosmosdb_sql.azurerm_cosmosdb_account.cosmosdb":                    expectedSqlAccountResult,
			"module.cosmosdb_graph.azurerm_cosmosdb_account.cosmosdb":                  expectedGraphAccountResult,
			"module.cosmosdb_sql.azurerm_cosmosdb_sql_database.cosmos_dbs[0]":          expectedDatabaseResult,
			"module.cosmosdb_graph.azurerm_cosmosdb_gremlin_database.cosmos_dbs[0]":    expectedDatabaseResult,
			"module.cosmosdb_graph.azurerm_cosmosdb_gremlin_graph.cosmos_graphs[0]":    expectedGraphResult,
			"module.cosmosdb_sql.azurerm_cosmosdb_sql_container.cosmos_collections[0]": expectedContainerResult,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
