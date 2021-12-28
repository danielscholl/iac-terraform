##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################
locals {
  identity_is_principal = var.client_id != "" && var.client_secret != "" && var.identity_type == "SystemAssigned" ? true : false
  identity_is_managed = var.identity_type == "UserAssigned" && var.user_assigned_identity_id == null ? true : false
  identity_id = var.identity_type == "UserAssigned" && var.user_assigned_identity_id == null ? azurerm_user_assigned_identity.main.0.id : var.user_assigned_identity_id
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_public_ip" "aks_egress_ip" {
  // Splits the Resource Id for the Egress IP to get the name
  name                = split("/", tolist(azurerm_kubernetes_cluster.main.network_profile[0].load_balancer_profile[0].effective_outbound_ips)[0])[8]
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
}

data "azurerm_subscription" "current" {}

resource "random_id" "main" {
  keepers = {
    group_name = data.azurerm_resource_group.main.name
  }

  byte_length = 8
}

resource "azurerm_user_assigned_identity" "main" {
  count = var.identity_type == "UserAssigned" && var.user_assigned_identity_id == null ? 1 : 0
  
  name                = lower(var.name)
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
}

resource "azurerm_log_analytics_workspace" "main" {
  count = var.enable_capability_monitoring && var.log_analytics_id == "" ? 1 : 0

  name                = lower(var.name)
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "main" {
  count = var.enable_capability_monitoring && var.log_analytics_id == "" ? 1 : 0

  solution_name       = "ContainerInsights"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  workspace_resource_id = azurerm_log_analytics_workspace.main.0.id
  workspace_name        = azurerm_log_analytics_workspace.main.0.name

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
  private_cluster_enabled = var.private_cluster_enabled

  linux_profile {
    admin_username = var.admin_user

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      orchestrator_version   = var.orchestrator_version
      name                   = var.default_pool_name
      node_count             = var.default_pool_count
      vm_size                = var.default_pool_vm_size
      os_disk_size_gb        = var.default_pool_disk_size
      vnet_subnet_id         = var.vnet_subnet_id
      enable_auto_scaling    = var.enable_auto_scaling
      max_count              = null
      min_count              = null
      enable_node_public_ip  = var.enable_node_public_ip
      availability_zones     = var.default_pool_zones
      node_labels            = var.default_pool_labels
      type                   = var.default_pool_type
      tags                   = merge(var.resource_tags, var.default_pool_tags)
      max_pods               = var.default_pool_max_pods
      enable_host_encryption = var.enable_host_encryption
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      orchestrator_version   = var.orchestrator_version
      name                   = var.default_pool_name
      vm_size                = var.default_pool_vm_size
      os_disk_size_gb        = var.default_pool_disk_size
      vnet_subnet_id         = var.vnet_subnet_id
      enable_auto_scaling    = var.enable_auto_scaling
      max_count              = var.default_pool_max_count
      min_count              = var.default_pool_min_count
      enable_node_public_ip  = var.enable_node_public_ip
      availability_zones     = var.default_pool_zones
      node_labels            = var.default_pool_labels
      type                   = var.default_pool_type
      tags                   = merge(var.resource_tags, var.default_pool_tags)
      max_pods               = var.default_pool_max_pods
      enable_host_encryption = var.enable_host_encryption
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_ip
    docker_bridge_cidr = var.docker_cidr
    outbound_type      = var.network_outbound_type
    pod_cidr           = var.network_pod_cidr
    service_cidr       = var.service_cidr
  }

  dynamic "service_principal" {
    for_each = local.identity_is_principal ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic "identity" {
    for_each = !local.identity_is_managed && !local.identity_is_principal ? ["identity"] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = local.identity_is_managed  ? ["identity"] : []
    content {
      type                      = var.identity_type
      user_assigned_identity_id = local.identity_id
    }
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    azure_policy {
      enabled = var.enable_capability_policy
    }

    dynamic "oms_agent" {
      for_each = var.enable_capability_monitoring ? [{
        enabled                    = false
      }] : []
      content {
        enabled                    = true
        log_analytics_workspace_id = var.log_analytics_id == "" ? azurerm_log_analytics_workspace.main.0.id : var.log_analytics_id
      }
    }

    dynamic "azure_keyvault_secrets_provider" {
      for_each = var.enable_capability_keyvault ? [{
        enabled                    = false
      }] : []
      content {
        enabled                    = true
        secret_rotation_enabled    = true
        secret_identity = {
          user_assigned_identity_id = local.identity_id
        }
      }
    }
  }

   role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && !var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.rbac_aad_client_app_id
        server_app_id     = var.rbac_aad_server_app_id
        server_app_secret = var.rbac_aad_server_app_secret
      }
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      addon_profile[0].oms_agent[0].log_analytics_workspace_id
    ]
  }
}

# resource "azurerm_kubernetes_cluster_node_pool" "internal" {
#   count = var.pool_count
# 
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
#   name                  = "poolz${count.index + 1}"
#   node_count            = var.agent_vm_count
#   vm_size               = var.agent_vm_size
#   os_disk_size_gb       = var.agent_vm_disk
#   vnet_subnet_id        = var.vnet_subnet_id
#   enable_auto_scaling   = var.enable_auto_scaling
#   max_pods              = var.max_pods
#   max_count             = var.enable_auto_scaling == true ? var.max_node_count : null
#   min_count             = var.enable_auto_scaling == true ? var.agent_vm_count : null
#   availability_zones    = [tostring(count.index + 1)]
#   node_labels           = var.node_labels
#   node_taints           = ["app=osdu:NoSchedule"]
#   mode                  = "User"
#   orchestrator_version  = var.kubernetes_version
# }
# 