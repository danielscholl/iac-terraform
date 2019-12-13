##############################################################
# This module allows the creation of a Resource Group
##############################################################

output "name" {
  description = "Then name of the Resource Group."
  value = "${azurerm_resource_group.module_resourcegroup.name}"
}

output "location" {
  description = "Then location of the Resource Group."
  value = "${azurerm_resource_group.module_resourcegroup.location}"
}

output "id" {
  description = "Then id of the Resource Group."
  value = "${azurerm_resource_group.module_resourcegroup.id}"
}

output "random" {
  description = "A random string derived from the Resource Group."
  value = "${random_id.randomId.hex}"
}
