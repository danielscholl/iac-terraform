
locals {
  // topics_name_id_flattened is used to create the map of Topic Name to Topic Id.
  topics_name_id_flattened = flatten([
    for topic in azurerm_eventgrid_topic.main : [
      {
        key   = topic.name
        value = topic.id
      }
    ]
  ])

  // topics_name_key_flattened is used to create the map of Topic Name to Topic Primary Key.
  topics_name_key_flattened = flatten([
    for topic in azurerm_eventgrid_topic.main : [
      {
        key   = topic.name
        value = topic.primary_access_key
      }
    ]
  ])
}

output "name" {
  value       = azurerm_eventgrid_domain.main.name
  description = "The domain name."
}

output "id" {
  value       = azurerm_eventgrid_domain.main.id
  description = "The event grid domain id."
}

output "primary_access_key" {
  description = "The primary shared access key associated with the eventgrid Domain."
  value       = azurerm_eventgrid_domain.main.primary_access_key
}

output "topics" {
  description = "The Topic Name to Topic Id map for the given list of topics."
  value       = { for item in local.topics_name_id_flattened : item.key => item.value }
}

output "topic_accesskey_map" {
  description = "The Topic Name to Topic Access Key map for the given list of topics."
  value       = { for item in local.topics_name_key_flattened : item.key => item.value }
}