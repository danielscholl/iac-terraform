package test

import (
	"crypto/tls"
	// "fmt"
	"os"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHttpExample(t *testing.T) {
	t.Parallel()

	// workspace := fmt.Sprintf("sw")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: ".",
		Upgrade:      true,

		BackendConfig: map[string]interface{}{
			"storage_account_name": os.Getenv("TF_VAR_remote_state_account"),
			"container_name":       os.Getenv("TF_VAR_remote_state_container"),
		},

		Vars: map[string]interface{}{
			"name":                       "simpleweb",
			"location":                   "eastus2",
			"randomization_level":        8,
			"docker_registry_server_url": "mcr.microsoft.com",
			"deployment_targets": []interface{}{
				map[string]interface{}{
					"app_name":                 "app",
					"image_name":               "azuredocs/aci-helloworld",
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
	// defer terraform.Destroy(t, terraformOptions)

	// terraform.Init(t, terraformOptions)
	// terraform.WorkspaceSelectOrNew(t, terraformOptions, workspace)
	// terraform.Plan(t, terraformOptions)
	// terraform.Apply(t, terraformOptions)

	homepage := terraform.Output(t, terraformOptions, "app_service_default_hostname")

	http_helper.HttpGetWithRetryWithCustomValidation(t, homepage, &tlsConfig, maxRetries, timeBetweenRetries, func(status int, content string) bool {
		return status == 200 &&
			strings.Contains(content, "Welcome to Azure Container Instances!")
	})
}
