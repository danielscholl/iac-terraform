##############################################################
# This module allows the creation of an Elastic Cloud Kubernetes
##############################################################

resource "helm_release" "eck-operator" {
  name       = "elastic-operator"
  depends_on = [module.kubernetes]

  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  version          = [var.operator_version]
  namespace        = "elastic-system"
  create_namespace = true

  set {
    name  = "nodeSelector.agentpool"
    value = "default"
  }
}
