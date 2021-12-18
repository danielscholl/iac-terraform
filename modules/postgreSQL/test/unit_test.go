package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "postgreSQL-"
var location = "eastus2"
var count = 11

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

	expectedResult := asMap(t, `{
		"administrator_login" : "test",
		"sku_name" : "GP_Gen5_4",
		"auto_grow_enabled" : true,
		"backup_retention_days" : 7,
		"geo_redundant_backup_enabled" : true,
		"public_network_access_enabled" : false,
		"ssl_enforcement_enabled" : true,
		"ssl_minimal_tls_version_enforced" : "TLSEnforcementDisabled",
		"version" : "10.0",
		"storage_mb" : 5120
	}`)

	expectedFirewallRule := asMap(t, `{
		"start_ip_address" : "10.0.0.2",
		"end_ip_address" : "10.0.0.8"
	}`)

	expectedConfig := asMap(t, `{
		"name" : "config",
		"value" : "test"
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.postgreSQL.azurerm_postgresql_server.main":           expectedResult,
			"module.postgreSQL.azurerm_postgresql_configuration.main[0]": expectedConfig,
			"module.postgreSQL.azurerm_postgresql_firewall_rule.main[0]": expectedFirewallRule,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
