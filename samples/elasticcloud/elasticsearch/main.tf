resource "helm_release" "elasticsearch" {
  name  = (var.helm_name != null ? var.helm_name : "elasticsearch-${var.name}")
  chart = "${path.module}/chart"

  namespace        = var.namespace
  create_namespace = var.create_namespace

  values = [<<-EOT
  name: ${var.name}
  application: sample
  agentPool: public
  elasticsearch:
    version: 7.11.2
    nodeCount: 3
    storagePerNodeGB: 128
  resources:
    limits:
      cpu: 2
      memory: 8
    requests:
      cpu: 0.2
  EOT
  ]
}
