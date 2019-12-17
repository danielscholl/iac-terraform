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

var workspace = fmt.Sprintf("webdata-%s", random.UniqueId())
var name = fmt.Sprintf("webdata-test-%s", random.UniqueId())
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

	expectedKeyVault := asMap(t, `{
		"sku_name": "standard"
	}`)

	expectedServicePrincipalKVPolicies := asMap(t, `{
		"certificate_permissions": ["create", "delete", "get", "list"],
		"key_permissions":         ["create", "delete", "get"],
		"secret_permissions":      ["delete", "get", "set", "list"]
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

	expectedCosmosDb := asMap(t, `{
    "kind": "GlobalDocumentDB",
    "enable_automatic_failover": false,
    "enable_multiple_write_locations": false,
    "is_virtual_network_filter_enabled": false,
    "offer_type": "Standard",
    "consistency_policy": [{
      "consistency_level": "Session",
      "max_interval_in_seconds": 5,
      "max_staleness_prefix": 100
    }],
    "geo_location": [{
      "failover_priority": 0,
      "location": "`+location+`"
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
		
		"site_config": [{
			"always_on": true,
			"linux_fx_version": "DOCKER|mcr.microsoft.com/azuredocs/aci-helloworld:latest"
		}]
	}`)

	expectedWebSlot := asMap(t, `{
		"enabled": true,
		"https_only": false,
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
		ExpectedResourceCount: 19,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"azurerm_resource_group.rg":                  expectedResourceGroup,
			"module.keyvault.azurerm_key_vault.keyvault": expectedKeyVault,
			"module.keyvault.module.deployment_service_principal_keyvault_access_policies.azurerm_key_vault_access_policy.main[0]": expectedServicePrincipalKVPolicies,
			"module.cosmosdb.azurerm_cosmosdb_account.account":                                                                     expectedCosmosDb,
			"module.service_plan.azurerm_app_service_plan.main":                                                                    expectedServicePlan,
			"module.service_plan.azurerm_monitor_autoscale_setting.main":                                                           expectedScaling,
			"module.app_service.azurerm_app_service.main[0]":                                                                       expectedWebApp,
			"module.app_service.azurerm_app_service_slot.staging[0]":                                                               expectedWebSlot,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
