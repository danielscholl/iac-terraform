output "name" {
  description = "The name of the service plan created."
  value       = azurerm_app_service_plan.main.name
}

output "id" {
  value = azurerm_app_service_plan.main.id
}

