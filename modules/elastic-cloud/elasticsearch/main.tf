resource "helm_release" "elasticsearch" {
  name  = (var.helm_name != null ? var.helm_name : "elasticsearch")
  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = var.create_namespace

  values = [<<-EOT
  agentPool: ${var.agent_pool}
  elasticsearch:
    nodeCount: ${var.node_count}
    storagePerNodeGB: ${var.storage}
  resources:
    limits:
      cpu: ${var.cpu}
      memory: ${var.memory}
  EOT
  ]
}
