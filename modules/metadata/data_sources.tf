data "azurerm_subscription" "current" {}

locals {
  naming_rules = yamldecode(var.naming_rules)

  # Validate required inputs
  valid_environment = can(local.naming_rules.environment.allowed_values[var.environment]) ? null : file("ERROR: invalid input value for environment")
  valid_location    = can(local.naming_rules.azureRegion.allowed_values[var.location]) ? null : file("ERROR: invalid input value for location")

  # Validate optional inputs

  # Do no validate inputs for sandboxes or greenfield which need more flexibility
  valid_product = var.environment == "sandbox" || var.environment == "greenfield" || var.product == "" || can(local.naming_rules.product.allowed_values[var.product]) ? null : file("ERROR: invalid input value for product")
}
