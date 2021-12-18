package test

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/microsoft/cobalt/test-harness/infratests"
)

var workspace = "iac-terraform-" + strings.ToLower(random.UniqueId())
var location = "eastus"
var count = 4

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
		"capacity" : 1,
		"enable_non_ssl_port" : false,
		"family" : "C",
		"minimum_tls_version" : "1.2",
		"shard_count" : 0,
		"sku_name" : "Standard",
		"redis_configuration" : [{
			"enable_authentication" : true,
			"maxfragmentationmemory_reserved" : 50,
			"maxmemory_delta" : 50,
			"maxmemory_policy" : "volatile-lru",
			"maxmemory_reserved" : 50
		}]
	}`)

	testFixture := infratests.UnitTestFixture{
		GoTest:                t,
		TfOptions:             tfOptions,
		Workspace:             workspace,
		PlanAssertions:        nil,
		ExpectedResourceCount: count,
		ExpectedResourceAttributeValues: infratests.ResourceDescription{
			"module.redis-cache.azurerm_redis_cache.arc": expectedResult,
		},
	}

	infratests.RunUnitTests(&testFixture)
}
