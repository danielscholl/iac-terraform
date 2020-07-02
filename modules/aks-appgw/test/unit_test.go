package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "cluster-"
var location = "eastus"
var count = 15

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

	ipExpectedResult := asMap(t, `{
		"sku": "Standard",
		"allocation_method": "Static"
	}`)

	gatewayExpectedResult := asMap(t, `{
		"autoscale_configuration": [{
			"min_capacity": 2
		}],
		"identity": [{
			"type": "UserAssigned"
		}],
		"request_routing_rule": [{
			"rule_type": "Basic"
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.appgateway.azurerm_public_ip.main":           ipExpectedResult,
			"module.appgateway.azurerm_application_gateway.main": gatewayExpectedResult,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
