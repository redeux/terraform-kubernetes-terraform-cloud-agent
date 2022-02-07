resource "kubernetes_deployment" "tfc_agent" {
  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name      = "terraform-cloud-agent"
    namespace = var.create_namespace ? kubernetes_namespace.tfc_agent_namespace[0].metadata[0].name : var.namespace
  }

  spec {
    replicas = var.agent_replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name"       = "terraform-cloud-agent"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"           = "terraform-cloud-agent"
          "app.kubernetes.io/version"        = var.agent_version
          "app.kubernetes.io/module-version" = local.module-version
          "app.kubernetes.io/managed-by"     = "terraform"
        }
      }

      spec {
        container {
          image = "${var.agent_image}:${var.agent_version}"
          name  = "terraform-cloud-agent"
          env {
            name = "TFC_AGENT_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.tfc_agent_token.metadata[0].name
                key  = "token"
              }
            }
          }

          env {
            name = "TFC_AGENT_NAME"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.tfc_agent_configuration.metadata[0].name
                key  = "name"
              }
            }
          }

          env {
            name = "TFC_ADDRESS"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.tfc_agent_configuration.metadata[0].name
                key  = "url"
              }
            }
          }

          env {
            name = "TFC_AGENT_LOG_LEVEL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.tfc_agent_configuration.metadata[0].name
                key  = "log-level"
              }
            }
          }
          env {
            name = "TFC_AGENT_AUTO_UPDATE"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.tfc_agent_configuration.metadata[0].name
                key  = "disable-update"
              }
            }
          }
          resources {
            requests = {
              cpu    = var.requests_cpu
              memory = var.requests_memory
            }
            limits = {
              cpu    = var.limits_cpu
              memory = var.limits_memory
            }
          }
        }

        automount_service_account_token = true
        service_account_name            = var.cluster_access ? kubernetes_service_account.tfc_agent_service_account[0].metadata[0].name : "default"
      }
    }
  }
}
