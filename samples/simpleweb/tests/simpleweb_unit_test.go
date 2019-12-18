package test

import (
	"encoding/json"
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var workspace = fmt.Sprintf("simpleweb-%s", random.UniqueId())
var name = fmt.Sprintf("simpleweb-test-%s", random.UniqueId())
var location = "eastus"

var tfOptions = &terraform.Options{
	TerraformDir: "../../",
	Upgrade:      true,
	BackendConfig: map[string]interface{}{
		"storage_account_name": os.Getenv("TF_VAR_remote_state_account"),
		"container_name":       os.Getenv("TF_VAR_remote_state_container"),
	},
	Vars: map[string]interface{}{
		"name":                       name,
		"location":                   location,
		"randomization_level":        3,
		"docker_registry_server_url": "mcr.microsoft.com",
		"deployment_targets": []interface{}{
			map[string]interface{}{
				"app_name":                 "test",
				"image_name":               "azuredocs/aci-helloworld",
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
			"DOCKER_REGISTRY_SERVER_URL": "https://mcr.microsoft.com"
		},
		"site_config": [{
			"always_on": true,
			"linux_fx_version": "DOCKER|mcr.microsoft.com/azuredocs/aci-helloworld:latest"
		}]
	}`)

	expectedWebSlot := asMap(t, `{
		"enabled": true,
		"https_only": false,
		"app_settings": {
			"WEBSITES_ENABLE_APP_SERVICE_STORAGE": "false",
			"DOCKER_REGISTRY_SERVER_URL": "https://mcr.microsoft.com"
		},
		"site_config": [{
			"always_on": true,
			"linux_fx_version": "DOCKER|mcr.microsoft.com/azuredocs/aci-helloworld:latest"
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             workspace,
		PlanAssertions:        nil,
		ExpectedResourceCount: 10,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"azurerm_resource_group.rg":                                  expectedResourceGroup,
			"module.service_plan.azurerm_app_service_plan.main":          expectedServicePlan,
			"module.service_plan.azurerm_monitor_autoscale_setting.main": expectedScaling,
			"module.app_service.azurerm_app_service.main[0]":             expectedWebApp,
			"module.app_service.azurerm_app_service_slot.staging[0]":     expectedWebSlot,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
