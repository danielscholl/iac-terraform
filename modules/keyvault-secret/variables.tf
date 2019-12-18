##############################################################
# This module allows the creation of a Key Vault Secret
##############################################################

variable "keyvault_id" {
  type        = string
  description = "Id of the Key Vault to store the secret in."
}

variable "secrets" {
  description = "Key/value pair of keyvault secret names and corresponding secret value."
  type        = map(string)
}
