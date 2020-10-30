resource "kubernetes_config_map" "tfc_agent_configuration" {
  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name      = "tfc-agent-configuration"
    namespace = var.create_namespace ? kubernetes_namespace.tfc_agent_namespace[0].metadata[0].name : var.namespace
  }

  data = {
    name           = var.agent_token_name
    url            = var.tfc_url
    log-level      = var.agent_log_level
    disable-update = tostring(var.agent_disable_update)
  }
}