##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################

locals {
  msi_identity_type = "SystemAssigned"
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subscription" "current" {}

resource "random_id" "main" {
  keepers = {
    group_name = data.azurerm_resource_group.main.name
  }

  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = lower("${var.name}")
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "main" {
  solution_name       = "ContainerInsights"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = var.resource_tags

  dns_prefix         = var.dns_prefix
  kubernetes_version = var.kubernetes_version
  

  linux_profile {
    admin_username = var.admin_user

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name            = "default"
    node_count      = var.agent_vm_count
    vm_size         = var.agent_vm_size
    os_disk_size_gb = 30
    vnet_subnet_id  = var.vnet_subnet_id
    max_pods           = var.max_pods
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_ip
    docker_bridge_cidr = var.docker_cidr
  }

  role_based_access_control {
    enabled = true
  }

  dynamic "service_principal" {
    for_each = !var.msi_enabled && var.service_principal_id != "" ? [{
      client_id     = var.service_principal_id
      client_secret = var.service_principal_secret
    }] : []
    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.oms_agent_enabled
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
    }
  }

  # This dynamic block enables managed service identity for the cluster
  # in the case that the following holds true:
  #   1: the msi_enabled input variable is set to true
  dynamic "identity" {
    for_each = var.msi_enabled ? [local.msi_identity_type] : []
    content {
      type = identity.value
    }
  }
}

data "external" "msi_object_id" {
  depends_on = [azurerm_kubernetes_cluster.main]
  program = [
    "${path.module}/aks_msi_client_id_query.sh",
    var.name,
    data.azurerm_resource_group.main.name,
    data.azurerm_subscription.current.subscription_id
  ]
}