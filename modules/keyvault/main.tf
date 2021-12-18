##############################################################
# This module allows the creation of a Key Vault
##############################################################

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}


# Note: Any access policies needed for the keyvault should be created using
# the `keyvault-policy` module. More information on why can be found here:
#   https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#access_policy
resource "azurerm_key_vault" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 90
  purge_protection_enabled   = false

  sku_name = var.sku

  # This block configures VNET integration if a subnet whitelist is specified
  dynamic "network_acls" {
    # this block allows the loop to run 1 or 0 times based on if the resource ip whitelist or subnet id whitelist is provided.
    for_each = length(concat(var.resource_ip_whitelist, var.subnet_id_whitelist)) == 0 ? [] : [""]
    content {
      bypass                     = "None"
      default_action             = "Deny"
      virtual_network_subnet_ids = var.subnet_id_whitelist
      ip_rules                   = var.resource_ip_whitelist
    }
  }

  tags = var.resource_tags
}

resource "azurerm_key_vault_secret" "main" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [module.deployment_service_principal_keyvault_access_policies]
}

module "deployment_service_principal_keyvault_access_policies" {
  source                  = "../keyvault-policy"
  vault_id                = azurerm_key_vault.main.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_ids              = [data.azurerm_client_config.current.object_id]
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  certificate_permissions = var.certificate_permissions
}
