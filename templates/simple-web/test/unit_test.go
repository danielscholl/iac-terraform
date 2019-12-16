package test

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var workspace = fmt.Sprintf("simple-web-%s", random.UniqueId())
var name = fmt.Sprintf("iac-terraform-simple-web-test-%s", random.UniqueId())
var location = "eastus"

var tfOptions = &terraform.Options{
	TerraformDir: "../",
	Upgrade:      true,
	Vars: map[string]interface{}{
		"name":                name,
		"location":            location,
		"randomization_level": 3,
		"deployment_targets": []interface{}{
			map[string]interface{}{
				"app_name":                 "web",
				"image_name":               "mcr.microsoft.com/azuredocs/aci-helloworld",
				"image_release_tag_prefix": "latest",
			},
		},
	},
}

func asMap(t *testing.T, jsonString string) map[string]interface{} {
	var theMap map[string]interface{}
	if err := json.Unmarshal([]byte(jsonString), &theMap); err != nil {
		t.Fatal(err)
	}
	return theMap
}

func TestTemplate(t *testing.T) {

	expectedResourceGroup := asMap(t, `{
    "location": "`+location+`"
	}`)

	expectedServicePlan := asMap(t, `{
    "kind": "Linux",
    "reserved": true,
    "sku": [{
      "capacity": 1,
      "size": "S1",
      "tier": "Standard"
    }]
	}`)

	expectedScaling := asMap(t, `{
		"enabled": true,
		"notification": [{
      "email": [{
				"send_to_subscription_administrator": true
			}]
    }]
	}`)

	expectedWebApp := asMap(t, `{
		"enabled": true,
		"https_only": false,
		"app_settings": {
			"WEBSITES_ENABLE_APP_SERVICE_STORAGE": "false",
			"DOCKER_REGISTRY_SERVER_URL": "https://docker.io"
		},
		"site_config": [{
			"always_on": true,
			"linux_fx_version": "DOCKER|docker.io/mcr.microsoft.com/azuredocs/aci-helloworld:latest"
		}]
	}`)

	expectedWebSlot := asMap(t, `{
		"enabled": true,
		"https_only": false,
		"app_settings": {
			"WEBSITES_ENABLE_APP_SERVICE_STORAGE": "false",
			"DOCKER_REGISTRY_SERVER_URL": "https://docker.io"
		},
		"site_config": [{
			"always_on": true,
			"linux_fx_version": "DOCKER|docker.io/mcr.microsoft.com/azuredocs/aci-helloworld:latest"
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             workspace,
		PlanAssertions:        nil,
		ExpectedResourceCount: 11,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"azurerm_resource_group.rg":                                                    expectedResourceGroup,
			"module.service_plan.azurerm_app_service_plan.svcplan":                         expectedServicePlan,
			"module.service_plan.azurerm_monitor_autoscale_setting.app_service_auto_scale": expectedScaling,
			"module.app_service.azurerm_app_service.appsvc[0]":                             expectedWebApp,
			"module.app_service.azurerm_app_service_slot.staging[0]":                       expectedWebSlot,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
