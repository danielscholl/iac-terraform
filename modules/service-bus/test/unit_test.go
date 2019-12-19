package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "app-service-"
var location = "eastus"
var count = 8

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
		"sku": "Standard",
		"capacity": 0
	}`)

	expectedTopic := asMap(t, `{
		"enable_partitioning": true,
		"status": "Active"
	}`)

	expectedAuthRule := asMap(t, `{
		"listen": true,
		"manage": false,
		"send": true
	}`)

	expectedQueue := asMap(t, `{
		"dead_lettering_on_message_expiration": false,
		"enable_express": false,
		"enable_partitioning": false,
		"max_delivery_count": 10,
		"requires_duplicate_detection": false,
		"requires_session": false
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.service_bus.azurerm_servicebus_namespace.main":                   expectedResult,
			"module.service_bus.azurerm_servicebus_topic.main[0]":                    expectedTopic,
			"module.service_bus.azurerm_servicebus_topic_authorization_rule.main[0]": expectedAuthRule,
			"module.service_bus.azurerm_servicebus_queue.main[0]":                    expectedQueue,
			"module.service_bus.azurerm_servicebus_queue_authorization_rule.main[0]": expectedAuthRule,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
