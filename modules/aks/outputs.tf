##############################################################
# This module allows the creation of a Kubernetes Cluster
##############################################################

output "id" {
  value    = azurerm_kubernetes_cluster.id
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
}

output "kubeconfig_done" {
  value = join("", local_file.cluster_credentials.*.id)
}
