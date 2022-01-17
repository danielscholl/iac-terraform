
data "azurerm_resource_group" "node_rg" {
  name = var.aks_node_resource_group
}

resource "azurerm_role_assignment" "additional_managed_identity_operator" {
  for_each             = var.additional_scopes
  scope                = each.value
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_identity
}

resource "helm_release" "aad_pod_identity" {
  depends_on       = [azurerm_role_assignment.additional_managed_identity_operator]
  name             = "aad-pod-identity"
  namespace        = var.kubernetes_namespace
  create_namespace = var.create_kubernetes_namespace
  repository       = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart            = "aad-pod-identity"
  version          = var.helm_chart_version

  values = [<<-EOF
  rbac:
    allowAccessToSecrets: false
  installCRDs: ${var.install_crds}
  nmi:
    allowNetworkPluginKubenet: ${var.enable_kubenet_plugin}
  ${var.additional_yaml_config}
  EOF
  ]
}

module "identity" {
  depends_on = [helm_release.aad_pod_identity]
  source     = "./identity"
  for_each   = (var.identities == null ? {} : var.identities)

  namespace                   = each.value.namespace
  create_kubernetes_namespace = var.create_kubernetes_namespace

  identity_name        = each.value.name
  identity_client_id   = each.value.client_id
  identity_resource_id = each.value.resource_id
}
