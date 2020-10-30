resource "kubernetes_cluster_role_binding" "tfc_agent_cluster_role_binding" {
  count = var.cluster_access ? 1 : 0

  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name = "terraform-cloud-agent"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tfc_agent_role[0].metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tfc_agent_service_account[0].metadata[0].name
    namespace = var.namespace
  }
}