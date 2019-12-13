output "name" {
  description = "The name of the service plan created"
  value       = azurerm_app_service_plan.svcplan.name
}

output "kind" {
  description = "The kind of service plan created"
  value       = azurerm_app_service_plan.svcplan.kind
}

output "id" {
  value = azurerm_app_service_plan.svcplan.id
}

