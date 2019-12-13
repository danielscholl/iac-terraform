data "azurerm_resource_group" "group" {
  name = var.resource_group
}

resource "azurerm_app_service_plan" "svcplan" {
  name                       = var.name
  location                   = data.azurerm_resource_group.group.location
  resource_group_name        = data.azurerm_resource_group.group.name
  kind                       = var.kind
  tags                       = var.resource_tags
  reserved                   = var.kind == "Linux" ? true : var.isReserved
  app_service_environment_id = var.app_service_environment_id

  sku {
    tier     = var.tier
    size     = var.size
    capacity = var.capacity
  }
}

resource "azurerm_monitor_autoscale_setting" "app_service_auto_scale" {
  name                = "${var.name}-autoscale"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  target_resource_id  = azurerm_app_service_plan.svcplan.id

  profile {
    name = "Scaling Profile"

    capacity {
      default = 1
      minimum = var.autoscale_capacity_minimum
      maximum = azurerm_app_service_plan.svcplan.maximum_number_of_workers
    }

    dynamic "rule" {
      for_each = var.scaling_rules
      content {
        scale_action {
          direction = rule.value.scale_action.direction
          type      = rule.value.scale_action.type
          value     = rule.value.scale_action.value
          cooldown  = rule.value.scale_action.cooldown
        }
        metric_trigger {
          metric_resource_id = azurerm_app_service_plan.svcplan.id
          metric_name        = rule.value.metric_trigger.metric_name
          time_grain         = rule.value.metric_trigger.time_grain
          statistic          = rule.value.metric_trigger.statistic
          time_window        = rule.value.metric_trigger.time_window
          time_aggregation   = rule.value.metric_trigger.time_aggregation
          operator           = rule.value.metric_trigger.operator
          threshold          = rule.value.metric_trigger.threshold
        }
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
    }
  }
}

