##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################

resource "local_file" "cluster_credentials" {
  count             = var.kubeconfig_to_disk ? 1 : 0
  sensitive_content = azurerm_kubernetes_cluster.main.kube_config_raw
  filename          = "${var.output_directory}/${var.kubeconfig_filename}"

  depends_on = [azurerm_kubernetes_cluster.main]
}