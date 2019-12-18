# Introduction
Infrastructure as Code using Terraform - Module Development

__Prerequisites__

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed.

  >Assumes CLI Version = azure-cli (2.0.75)

* HashiCorp [Terraform](https://terraform.io/downloads.html) installed.

  ```bash
  export VER="0.12.18"
  wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
  unzip terraform_${VER}_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  ```

__Setup Terraform Environment Variables__

Generate Azure client id and secret.

> After creating a Service Principal you __MUST__ add API access for _Windows Azure Active Directory_ and enable the following permissions
> - Read and write all applications
> - Sign in and read user profile

```bash
# Create a Service Principal
Subscription=$(az account show --query id -otsv)
az ad sp create-for-rbac --name "Terraform-Principal" --role="Owner" --scopes="/subscriptions/$Subscription"

# Expected Result
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "Terraform-Principal",
  "name": "http://Terraform-Principal",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```

`appId` -> Client id.
`password` -> Client secret.
`tenant` -> Tenant id.

Export environment variables to configure the [Azure](https://www.terraform.io/docs/providers/azurerm/index.html) Terraform provider.

>A great tool to do this automatically with is [direnv](https://direnv.net/).

```bash
export ARM_SUBSCRIPTION_ID="SUBSCRIPTION_ID"
export ARM_TENANT_ID="TENANT_ID"
export ARM_CLIENT_ID="CLIENT_ID"
export ARM_CLIENT_SECRET="CLIENT_SECRET"
export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}

TF_VAR_remote_state_account="STORAGE_ACCOUNT"
TF_VAR_remote_state_container="remote-state-container"
```


__Setup Terraform Azure Backend State__

Terraform requires state to be stored in some location.  This state can be stored in [Azure Blob](https://www.terraform.io/docs/backends/types/azurerm.html) if desired. _(optional)_

Execute the init-backend-state.sh script to create the required Azure Resources.

- Resource Group _(or existing)_ to hold resources
- Storage Account _(or existing)_ for blob storage
- Storage Container _(or existing)_ for state blob
- Key Vault _(or existing)_ for storage account key

```bash
ResourceGroup="tfstate"
StorageAccount="tfstatestorage"  # Must be unique
KeyVault="tfstate"
./scripts/init-backend-state.sh $ResourceGroup $StorageAccount $KeyVault

# Expected Result
Creating Terraform Backend Store
------------------------------------
Logging in and setting subscription...
Creating the Resource Group...
Creating the Storage Account...
Retrieving the Storage Account Key...
Creating the Storage Account Container...
Creating the Key Vault...
Adding Storage Key to Vault...
------------------------------------

TF_VAR_remote_state_account=tfstate
TF_VAR_remote_state_container=remote-state-container

Run the following command to initialize Terraform to store its state into Azure Storage:
terraform init \
  -backend-config="storage_account_name=tfstate" \
  -backend-config="container_name=remote-state-container" \
  -backend-config="access_key=$(az keyvault secret show --name tfstate-storage-key --vault-name tfstate --query value -o tsv)" \
  -backend-config="key=terraform-ref-architecture-tfstate"
```



## Getting Started

1. Task Runner (mage)

```
iac-terraform task runner.

Targets:
  clean          Remove temporary build and test files.
  format         Lint Check both Terraform code and Go code.
  full           A build step that runs Clean, Format, Unit and Integration in sequence
  integration    Execute Template Integration Tests and fail if a integration test fails.
  lintGO         Lint Check Go and fail if files are not not formatted properly.
  lintTF         Lint Check Terraform and fail if files are not formatted properly.
  test           Execute Module Unit Tests and fail if a unit test fails.
  unit           Execute Template Unit Tests and fail if a unit test fails.
```

1. Deploying Example Templates

- simpleweb  - This template deploys a simple Web App with Containers
- webdata    - This template deploys a Web App with Containers with Cosmos DB Integration

```bash
# Change directory to Template
cd <desiredTemplate>

# Initialize the Modules
terraform init

# Test the plan
terraform plan

# Apply the Plan
terraform apply
```

1. Run Terraform process

```bash
# Initialize the Modules
terraform init

# Test the plan
terraform plan

# Apply the Plan
terraform apply
```
