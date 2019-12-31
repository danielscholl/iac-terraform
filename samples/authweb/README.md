# Authenticated Web Template

The `authweb` template runs a single public Linux Container within an Azure Application Service Plan and has configured easy auth AD protection requiring a valid user in AD to be able to access the application. A service principal with contributor rights to be able to manage the App Service Plan and both the Web App and Staging slot is also available. Finally the resource group is locked on deployment to protect it from accidental changes and deletion.


## Provisioned Resources

This deployment creates the following:

 1. Azure Resource Group
 2. Linux App Service Plan
 3. App Service and Container with a public IP.
 4. App Service Staging Slot

![Architecture](../../images/simpleweb_arch.png)


## Example Usage

1. Execute the following commands to set up your terraform workspace.

```bash
# This configures terraform to leverage a remote backend that will help you and your
# team keep consistent state
terraform init -backend-config "storage_account_name=${TF_VAR_remote_state_account}" -backend-config "container_name=${TF_VAR_remote_state_container}"

# This command configures terraform to use a workspace unique to you. This allows you to work
# without stepping over your teammate's deployments
terraform workspace new $USER || terraform workspace select $USER
```

2. Execute the following commands to provision resources.

```bash
# See what terraform will try to deploy without actually deploying
terraform plan

# Execute a deployment
terraform apply
```

3. Execute the following command to teardown your deployment and delete your resources.

_* Prior to destroying the resource group lock must be removed_

```bash
# Destroy resources and tear down deployment. Only do this if you want to destroy your deployment.
terraform destroy
```

#### Required Variables

 1. `name`: An identifier used to construct the names of all resources in this sample.
 2. `location`: The deployment location of resource group container for all your Azure resources.
 3. `docker_registry_server_url`: The docker registry where images reside.
 3. `deployment_targets`: The name key value pair where the key is representative to the app service name and value is the source container.


## Testing

Execute the following commands to test the sample.

```bash
# This executes the test
go test -v -timeout 7200s integration_test.go
```
