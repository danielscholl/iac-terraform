provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "app_monitoring" {
  source     = "../"
  depends_on = [module.resource_group]

  resource_group_name = module.resource_group.name
  action_group_name   = var.action_group_name

  action_group_email_receiver       = "var.action_group_email_receiver"
  metric_alert_name                 = "var.metric_alert_name"
  metric_alert_frequency            = "var.metric_alert_frequency"
  metric_alert_period               = "var.metric_alert_period"
  metric_alert_criteria_namespace   = "var.metric_alert_criteria_namespace"
  metric_alert_criteria_name        = "var.metric_alert_criteria_name"
  metric_alert_criteria_aggregation = "var.metric_alert_criteria_aggregation"
  metric_alert_criteria_operator    = "var.metric_alert_criteria_operator"
  metric_alert_criteria_threshold   = "var.metric_alert_criteria_threshold"
  monitoring_dimension_values       = "var.monitoring_dimension_values"
}
