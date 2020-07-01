/*
.Synopsis
   Terraform Main Control
.DESCRIPTION
   This file holds the main control and resoures for the iac-terraform AzureDevops Pipeline Bootstrap.
*/

terraform {
  required_version = ">= 0.12"
}

#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  version = "=2.16.0"
  features {}
}

provider "azuread" {
  version = "=0.10.0"
}

provider "azuredevops" {
  version = ">= 0.0.1"
}

provider "null" {
  version = "~>2.1.2"
}

provider "random" {
  version = "~>2.2"
}

#-------------------------------
# Application Variables  (variables.tf)
#-------------------------------
variable "environments" {
  description = "The environments and Az Subcriptions that IaC CI/CD will provision"
  type = list(object({
    environment = string,
    az_sub_id   = string
  }))
}

variable "project_name" {
  description = "The name of an existing project that will be provisioned to run the IaC CI/CD pipelines"
  default     = "IaC Terraform"
}

variable "name" {
  description = "An identifier used to construct the names of all resources in this template."
  type        = string
  default     = "iac-tf"
}

variable "location" {
  description = "The Azure region where all resources in this template should be created."
  type        = string
  default     = "centralus"
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 8
}

variable "lock" {
  description = "Should the resource group be locked"
  default     = false
}


#-------------------------------
# Private Variables  (common.tf)
#-------------------------------
locals {
  // Sanitized Names
  app_id   = random_string.workspace_scope.keepers.app_id
  location = replace(trimspace(lower(var.location)), "_", "-")
  ws_name  = random_string.workspace_scope.keepers.ws_name
  suffix   = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  // Base Names
  base_name    = length(local.app_id) > 0 ? "${local.ws_name}${local.suffix}-${local.app_id}" : "${local.ws_name}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"

  // Resolved resource names
  name                    = local.base_name
  storage_name            = "${replace(local.base_name_21, "-", "")}"
  ad_principal_name       = "${local.base_name}-principal"
  tf_state_container_name = "remote-state-container"

  // Service Principal Scopes
  contributor_scopes = concat(
    [module.storage_account.id]
  )

  // ADO Project Initialization
  project_name = azuredevops_project.main.project_name
  project_id   = azuredevops_project.main.id
}


#-------------------------------
# Application Resources  (common.tf)
#-------------------------------
resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name = replace(trimspace(lower(terraform.workspace)), "_", "-")
    app_id  = replace(trimspace(lower(var.name)), "_", "-")
  }

  length  = max(1, var.randomization_level) // error for zero-length
  special = false
  upper   = false
}

data "azurerm_subscription" "sub" {
}


#-------------------------------
# Resource Group
#-------------------------------
module "resource_group" {
  # Module Path
  source = "../../modules/resource-group"

  # Module variable
  name     = local.name
  location = local.location

  resource_tags = {
    environment = local.ws_name
  }
  isLocked = var.lock
}

#-------------------------------
# Storage Account
#-------------------------------
module "storage_account" {
  source              = "../../modules/storage-account"
  resource_group_name = module.resource_group.name
  name                = substr(local.storage_name, 0, 23)
  containers = [
    {
      name        = local.tf_state_container_name,
      access_type = "private"
    }
  ]

  resource_tags = {
    environment = local.ws_name
  }
}

#-------------------------------
# Service Principal with Role Assignments
#-------------------------------
module "service_principal" {
  source = "../../modules/service-principal"

  name = local.ad_principal_name

  scopes = local.contributor_scopes
  role   = "Contributor"
}



#-------------------------------
# ADO Project
#-------------------------------
resource "azuredevops_project" "main" {
  project_name = var.project_name
}

resource "azuredevops_variable_group" "core_vg" {
  project_id   = local.project_id
  name         = "iac-terraform-variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "AGENT_POOL"
    value = "Hosted Ubuntu 1604"
  }
  variable {
    name  = "BUILD_ARTIFACT_NAME"
    value = "iac-terraform"
  }
  variable {
    name  = "FORCE_RUN"
    value = "False"
  }
  variable {
    name  = "SERVICE_CONNECTION_NAME"
    value = azuredevops_serviceendpoint_azurerm.endpointazure.service_endpoint_name
  }
}



resource "azuredevops_variable_group" "stage_vg" {
  project_id   = local.project_id
  count        = length(var.environments)
  name         = format("%s Environment Variables", var.environments[count.index].environment)
  description  = "Managed by Terraform"
  allow_access = false

  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = var.environments[count.index].az_sub_id
  }

  variable {
    name  = "TF_VAR_location"
    value = format("tf%s", var.environments[count.index].environment)
  }

  variable {
    name  = "TF_VAR_remote_state_account"
    value = format("tf%s", var.environments[count.index].environment)
  }
  variable {
    name  = "TF_VAR_remote_state_container"
    value = local.tf_state_container_name
  }
}

resource "azuredevops_git_repository" "repo" {
  project_id = local.project_id
  name       = "Infrastructure"
  initialization {
    init_type  = "Clean" # Import not ready
    source_url = "https://github.com/danielscholl/iac-terraform.git"
  }
}

resource "azuredevops_build_definition" "build" {
  project_id = local.project_id
  name       = "Infrastructure"

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipeline.yml"
  }

  variable_groups = concat(
    [azuredevops_variable_group.core_vg.id],
    azuredevops_variable_group.stage_vg.*.id
  )
}


resource "azuredevops_serviceendpoint_azurerm" "endpointazure" {
  project_id            = local.project_id
  service_endpoint_name = "iac-terraform Service Connection"
  credentials {
    serviceprincipalid  = module.service_principal.client_id
    serviceprincipalkey = module.service_principal.client_secret
  }
  azurerm_spn_tenantid      = data.azurerm_subscription.sub.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.sub.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.sub.display_name
}



#-------------------------------
# Output Variables  (output.tf)
#-------------------------------
output "repo_clone_url" {
  description = "The Git repository where IaC templates are stored and watched for changes"
  value       = azuredevops_git_repository.repo.web_url
}