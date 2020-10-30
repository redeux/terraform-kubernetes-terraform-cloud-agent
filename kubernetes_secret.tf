resource "kubernetes_secret" "tfc_agent_token" {
  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name      = "tfc-agent-token"
    namespace = var.create_namespace ? kubernetes_namespace.tfc_agent_namespace[0].metadata[0].name : var.namespace
  }

  data = {
    "token" = var.agent_token_secret
  }
}