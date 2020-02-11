resource "null_resource" "enable_virtual_node_addon" {
  count = var.enable_virtual_node_addon ? 1 : 0

  provisioner "local-exec" {
    command = "az aks enable-addons --resource-group ${var.resource_group_name} --name ${var.name} --addons virtual-node --subnet-name ${var.name}-virtual-node-subnet"
  }
}