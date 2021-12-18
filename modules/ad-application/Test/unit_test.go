package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var name = "adapplication-"
var count = 3

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
		"display_name": "iac-terraform-ad-app",
		"fallback_public_client_enabled": false,
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
		}],
		"app_role": [{
			"description": "test",
			"display_name": "test",
			"enabled": true,
			"id": "497406e4-012a-4267-bf18-45a1cb148a01",
			"value": "test"
		}],
		"web": [{
			"homepage_url": "https://iac-terraform-ad-app"
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             name + random.UniqueId(),
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.ad-application.azuread_application.main": expectedResult,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
