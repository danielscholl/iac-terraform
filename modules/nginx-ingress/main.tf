##############################################################
# This module allows the creation of an NGINX Ingress Controller
##############################################################

locals {
  helm_chart      = "ingress-nginx"
  helm_repository = "https://kubernetes.github.io/ingress-nginx"
}

resource "helm_release" "nginx" {
  # name             = var.helm_release_name
  # namespace        = var.kubernetes_namespace
  # repository       = var.helm_repository
  # chart            = "ingress-nginx"
  # version          = var.helm_chart_version
  # create_namespace = var.kubernetes_create_namespace

  name             = var.name
  chart            = local.helm_chart
  namespace        = var.namespace
  repository       = local.helm_repository
  version          = var.chart_version
  create_namespace = var.kubernetes_create_namespace

  values = [
    yamlencode({
      controller = {
        replicaCount = var.replica_count
        ingressClass = var.ingress_class
        publishService = {
          enabled      = true
          pathOverride = "${var.namespace}/${var.name}-ingress-nginx-controller"
        }
        config = {
          ssl-redirect = var.enable_default_tls
        }
        service = {
          loadBalancerIP = var.load_balancer_ip
          annotations = var.ingress_type == "Internal" ? {
            "service.beta.kubernetes.io/azure-load-balancer-internal" : "true"
          } : {}
        }
      }
    }),
    var.additional_yaml_config
  ]
}

data "kubernetes_service" "nginx" {
  depends_on = [helm_release.nginx]
  metadata {
    name      = "${var.name}-ingress-nginx-controller"
    namespace = var.namespace
  }
}
