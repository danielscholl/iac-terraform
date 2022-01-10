##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_public_ip" "aks_egress_ip" {
  // Splits the Resource Id for the Egress IP to get the name
  name                = split("/", tolist(azurerm_kubernetes_cluster.main.network_profile[0].load_balancer_profile[0].effective_outbound_ips)[0])[8]
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = local.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.resource_tags

  sku_tier                = var.sku_tier
  kubernetes_version      = var.kubernetes_version
  node_resource_group     = local.node_resource_group
  dns_prefix              = local.dns_prefix
  private_cluster_enabled = var.enable_private_cluster

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = (var.network_profile_options == null ? null : var.network_profile_options.dns_service_ip)
    docker_bridge_cidr = (var.network_profile_options == null ? null : var.network_profile_options.docker_bridge_cidr)
    service_cidr       = (var.network_profile_options == null ? null : var.network_profile_options.service_cidr)
    outbound_type      = var.outbound_type
    pod_cidr           = (var.network_plugin == "kubenet" ? var.pod_cidr : null)
  }

  dynamic "windows_profile" {
    for_each = local.windows_nodes ? [1] : []
    content {
      admin_username = var.windows_profile.admin_username
      admin_password = var.windows_profile.admin_password
    }
  }

  dynamic "linux_profile" {
    for_each = local.linux_nodes ? [1] : []
    content {
      admin_username = var.linux_profile.admin_username
      ssh_key {
        key_data = var.linux_profile.ssh_key
      }
    }
  }

  default_node_pool {
    name                         = var.default_node_pool
    vm_size                      = local.node_pools[var.default_node_pool].vm_size
    os_disk_size_gb              = local.node_pools[var.default_node_pool].os_disk_size_gb
    os_disk_type                 = local.node_pools[var.default_node_pool].os_disk_type
    availability_zones           = local.node_pools[var.default_node_pool].availability_zones
    enable_auto_scaling          = local.node_pools[var.default_node_pool].enable_auto_scaling
    node_count                   = (local.node_pools[var.default_node_pool].enable_auto_scaling ? null : local.node_pools[var.default_node_pool].node_count)
    min_count                    = (local.node_pools[var.default_node_pool].enable_auto_scaling ? local.node_pools[var.default_node_pool].min_count : null)
    max_count                    = (local.node_pools[var.default_node_pool].enable_auto_scaling ? local.node_pools[var.default_node_pool].max_count : null)
    enable_host_encryption       = local.node_pools[var.default_node_pool].enable_host_encryption
    enable_node_public_ip        = local.node_pools[var.default_node_pool].enable_node_public_ip
    type                         = local.node_pools[var.default_node_pool].type
    only_critical_addons_enabled = local.node_pools[var.default_node_pool].only_critical_addons_enabled
    orchestrator_version         = local.node_pools[var.default_node_pool].orchestrator_version
    max_pods                     = local.node_pools[var.default_node_pool].max_pods
    node_labels                  = local.node_pools[var.default_node_pool].node_labels
    tags                         = local.node_pools[var.default_node_pool].tags
    vnet_subnet_id = (local.node_pools[var.default_node_pool].subnet != null ?
    var.virtual_network.subnets[local.node_pools[var.default_node_pool].subnet].id : null)

    upgrade_settings {
      max_surge = local.node_pools[var.default_node_pool].max_surge
    }
  }

  identity {
    type = var.identity_type
    user_assigned_identity_id = (var.identity_type == "SystemAssigned" ? null :
      (var.user_assigned_identity != null ?
        var.user_assigned_identity.id :
    azurerm_user_assigned_identity.main.0.id))
  }

  api_server_authorized_ip_ranges = local.api_server_authorized_ip_ranges

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    azure_policy {
      enabled = var.enable_policy
    }

    dynamic "oms_agent" {
      for_each = (var.log_analytics_workspace_id != null ? [1] : [])
      content {
        enabled                    = true
        log_analytics_workspace_id = var.log_analytics_workspace_id
      }
    }

    dynamic "azure_keyvault_secrets_provider" {
      for_each = var.enable_keyvault_secrets ? [{
        enabled = false
      }] : []
      content {
        enabled                 = true
        secret_rotation_enabled = true
        secret_identity = {
          user_assigned_identity_id = local.identity_id
        }
      }
    }
  }

  role_based_access_control {
    enabled = var.rbac.enabled
    dynamic "azure_active_directory" {
      for_each = (var.rbac.ad_integration ? [1] : [])
      content {
        managed                = true
        admin_group_object_ids = values(var.rbac_admin_object_ids)
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

resource "azurerm_role_assignment" "rbac_admin" {
  for_each             = (var.rbac.ad_integration ? var.rbac_admin_object_ids : {})
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

// Create any desired Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = local.additional_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id

  name                   = each.key
  vm_size                = each.value.vm_size
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  availability_zones     = each.value.availability_zones
  enable_auto_scaling    = each.value.enable_auto_scaling
  node_count             = (each.value.enable_auto_scaling ? null : each.value.node_count)
  min_count              = (each.value.enable_auto_scaling ? each.value.min_count : null)
  max_count              = (each.value.enable_auto_scaling ? each.value.max_count : null)
  os_type                = each.value.os_type
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  max_pods               = each.value.max_pods
  node_labels            = each.value.node_labels
  orchestrator_version   = each.value.orchestrator_version
  tags                   = each.value.tags
  vnet_subnet_id = (each.value.subnet != null ?
  var.virtual_network.subnets[each.value.subnet].id : null)

  node_taints                  = each.value.node_taints
  eviction_policy              = each.value.eviction_policy
  proximity_placement_group_id = each.value.proximity_placement_group_id
  spot_max_price               = each.value.spot_max_price
  priority                     = each.value.priority
  mode                         = each.value.mode

  upgrade_settings {
    max_surge = each.value.max_surge
  }
}

// AKS User Assigned Managed Identity - Auto Create if not provided
resource "azurerm_user_assigned_identity" "main" {
  count = (var.identity_type == "UserAssigned" && var.user_assigned_identity == null ? 1 : 0)

  name                = local.identity_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
}

// Give AKS Access to Operate the Network - AKS.identity.0.principal_id
resource "azurerm_role_assignment" "subnet_network_contributor" {
  for_each = (var.virtual_network == null ? {} : (var.configure_network_role ? var.virtual_network.subnets : {}))

  scope                = each.value.id
  role_definition_name = "Network Contributor"
  principal_id         = local.aks_identity_id
}

// Give AKS Access to Operate the Network - AKS.identity.0.principal_id
resource "azurerm_role_assignment" "route_table_network_contributor" {
  count = (var.virtual_network == null ? 0 : 1)

  scope                = var.virtual_network.route_table_id
  role_definition_name = "Network Contributor"
  principal_id         = local.aks_identity_id
}


data "azurerm_resource_group" "node_rg" {
  name = azurerm_kubernetes_cluster.main.node_resource_group
}

data "azurerm_user_assigned_identity" "agentpool" {
  name                = "${azurerm_kubernetes_cluster.main.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
}

// Give AKS Access rights to Operate the Node Resource Group
resource "azurerm_role_assignment" "agentpool_msi" {
  scope                            = data.azurerm_resource_group.node_rg.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = data.azurerm_user_assigned_identity.agentpool.principal_id
  skip_service_principal_aad_check = true
}

// Give AKS Access to Create and Remove VM's in Node Resource Group
resource "azurerm_role_assignment" "agentpool_vm" {
  scope                            = data.azurerm_resource_group.node_rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.agentpool.principal_id
  skip_service_principal_aad_check = true
}


// Give Kubelet Access to list or read a user-assigned managed identities in Group
resource "azurerm_role_assignment" "kubelet_managed_id_operator" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity.0.object_id
}


// Give Kubelet access to Pull from ACR's
resource "azurerm_role_assignment" "acr_pull" {
  for_each                         = var.acr_pull_access
  scope                            = each.value
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}
