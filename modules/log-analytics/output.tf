##############################################################
# This module allows the creation of a Log Analytics Workspace
##############################################################


output "id" {
  value = element(
    concat(
      azurerm_log_analytics_workspace.free.*.id,
      azurerm_log_analytics_workspace.nonfree.*.id,
      tolist([""])
    ),
    0
  )
}

output "primary_shared_key" {
  sensitive = true
  value = element(
    concat(
      azurerm_log_analytics_workspace.free.*.primary_shared_key,
      azurerm_log_analytics_workspace.nonfree.*.primary_shared_key,
      tolist([""])
    ),
    0
  )
}

output "secondary_shared_key" {
  sensitive = true
  value = element(
    concat(
      azurerm_log_analytics_workspace.free.*.secondary_shared_key,
      azurerm_log_analytics_workspace.nonfree.*.secondary_shared_key,
      tolist([""])
    ),
    0
  )
}

output "workspace_id" {
  value = element(
    concat(
      azurerm_log_analytics_workspace.free.*.workspace_id,
      azurerm_log_analytics_workspace.nonfree.*.workspace_id,
      tolist([""])
    ),
    0
  )
}

output "portal_url" {
  value = element(
    concat(
      azurerm_log_analytics_workspace.free.*.portal_url,
      azurerm_log_analytics_workspace.nonfree.*.portal_url,
      tolist([""])
    ),
    0
  )
}



# output "id" {
#   description = "The Log Analytics Workspace Id"
#   value       = azurerm_log_analytics_workspace.main.id
# }


# output "name" {
#   description = "The Log Analytics Workspace Name"
#   value       = azurerm_log_analytics_workspace.main.name
# }

# output "log_workspace_id" {
#   value = azurerm_log_analytics_workspace.main.workspace_id
# }

# output "log_workspace_key" {
#   value = azurerm_log_analytics_workspace.main.primary_shared_key
# }