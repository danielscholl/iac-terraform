package test

import (
	"crypto/tls"
	"fmt"
	"os"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHttpExample(t *testing.T) {
	t.Parallel()

	workspace := fmt.Sprintf("iac")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../",
		Upgrade:      true,

		BackendConfig: map[string]interface{}{
			"storage_account_name": os.Getenv("TF_VAR_remote_state_account"),
			"container_name":       os.Getenv("TF_VAR_remote_state_container"),
		},

		Vars: map[string]interface{}{
			"name":                    "webdata",
			"location":                "eastus2",
			"randomization_level":     8,
			"cosmosdb_container_name": "user",
			"deployment_targets": []interface{}{
				map[string]interface{}{
					"app_name":                 "test",
					"image_name":               "danielscholl/spring-user-api",
					"image_release_tag_prefix": "latest",
				},
			},
		},
	}

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, workspace)
	terraform.Plan(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	homepage := terraform.Output(t, terraformOptions, "app_service_default_hostname/api/user")

	// Verify that we get back a 200 OK with the expected instanceText
	http_helper.HttpGetWithRetry(t, homepage, &tlsConfig, 200, "[]", maxRetries, timeBetweenRetries)

}
