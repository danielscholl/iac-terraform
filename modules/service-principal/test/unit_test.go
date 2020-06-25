package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "serviceprincipal-"
var count = 7

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
		"available_to_other_tenants": false,
		"type": "webapp/api",
		"required_resource_access": [{
			"resource_app_id": "00000003-0000-0000-c000-000000000000",
			"resource_access": [{
				"id": "06da0dbc-49e2-44d2-8312-53f166ab848a",
				"type": "Scope"
			}, {
				"id": "e1fe6dd8-ba31-4d61-89e7-88639da4683d",
				"type": "Scope"
			}, {
				"id": "7ab1d382-f21e-4acd-a863-ba3e13f7da61",
				"type": "Role"
			}]
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.service_principal.azuread_application.main[0]": expectedResult,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
