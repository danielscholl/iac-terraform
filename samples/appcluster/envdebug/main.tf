resource "helm_release" "elasticsearch" {
  name  = (var.name != null ? var.name : "envdebug")
  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = var.create_namespace

  values = [<<-EOT
  agentPool: ${var.agent_pool}
  azure:
    enabled: false
  EOT
  ]
}
