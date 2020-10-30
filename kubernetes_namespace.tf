resource "kubernetes_namespace" "tfc_agent_namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name = var.namespace
  }
}