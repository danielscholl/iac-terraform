##############################################################
# This module allows the creation of a Storage Account
##############################################################

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "main" {
  name = (var.name == null ? "${local.name}${random_string.random.result}" : lower(var.name))

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.resource_tags

  account_kind             = var.account_kind
  account_tier             = local.account_tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier

  is_hns_enabled           = var.enable_hns
  large_file_share_enabled = var.enable_large_file_share

  allow_blob_public_access  = var.allow_blob_public_access
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  nfsv3_enabled             = var.nfsv3_enabled
  shared_access_key_enabled = var.shared_access_key_enabled

  # enrolls storage account into azure 'managed identities' authentication
  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }

  dynamic "blob_properties" {
    for_each = ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ? [1] : [])
    content {
      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.blob_delete_retention_days
        }
      }
      dynamic "cors_rule" {
        for_each = (var.blob_cors == null ? {} : var.blob_cors)
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = local.static_website_enabled
    content {
      index_document     = var.index_path
      error_404_document = var.custom_404_path
    }
  }

  network_rules {
    default_action             = var.default_network_rule
    ip_rules                   = values(var.access_list)
    virtual_network_subnet_ids = values(var.service_endpoints)
    bypass                     = var.traffic_bypass
  }
}

## azure reference https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal
resource "azurerm_storage_encryption_scope" "scope" {
  for_each = var.encryption_scopes

  name                               = each.key
  storage_account_id                 = azurerm_storage_account.main.id
  source                             = "Microsoft.Storage"
  infrastructure_encryption_required = each.value.enable_infrastructure_encryption
}

resource "azurerm_storage_container" "main" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.containers[count.index].access_type
}
