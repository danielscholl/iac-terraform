##############################################################
# This module allows the creation of an Elastic Cloud Kubernetes
##############################################################

locals {
  helm_chart      = "eck-operator"
  helm_repository = "https://helm.elastic.co"
}

resource "helm_release" "eck-operator" {
  name             = var.name
  chart            = local.helm_chart
  namespace        = var.namespace
  repository       = local.helm_repository
  create_namespace = var.kubernetes_create_namespace

  set {
    name  = "nodeSelector.agentpool"
    value = "default"
  }
}

module "elasticsearch" {
  depends_on = [helm_release.eck-operator]

  source = "./elasticsearch"

  for_each = (var.elasticsearch == null ? {} : var.elasticsearch)

  create_namespace = true
  namespace        = each.key
  agent_pool       = each.value.agent_pool

  node_count = each.value.node_count
  storage    = each.value.storage
  cpu        = each.value.cpu
  memory     = each.value.memory
}
