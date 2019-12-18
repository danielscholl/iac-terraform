package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "keyvault-"
var location = "eastus"
var count = 5

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
		"sku_name": "standard"
	}`)

	expectedPolicies := asMap(t, `{
		"certificate_permissions": ["create", "delete", "get", "list"],
		"key_permissions":         ["create", "delete", "get"],
		"secret_permissions":      ["delete", "get", "set", "list"]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.keyvault.azurerm_key_vault.main": expectedResult,
			"module.keyvault.module.deployment_service_principal_keyvault_access_policies.azurerm_key_vault_access_policy.main[0]": expectedPolicies,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
