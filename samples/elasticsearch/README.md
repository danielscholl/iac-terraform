# Elastic Cluster Template

The `elasticcluster` template provisions a kubernetes cluster with elastic search deployed.


## Provisioned Resources

This deployment creates the following:

 1. Azure Resource Group
 2. Virtual Network
 3. Kubernetes Cluster (AKS)
 4. ECK Operator
 5. Elastic Search


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

3. Execute the following command to teardown your deployment and delete your resources when done with them.

```bash
# Destroy resources and tear down deployment. Only do this if you want to destroy your deployment.
terraform destroy
```

#### Required Variables

 1. `name`: An identifier used to construct the names of all resources in this sample.
 2. `location`: The deployment location of resource group container for all your Azure resources.

