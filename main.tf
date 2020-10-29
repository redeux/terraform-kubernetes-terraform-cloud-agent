locals {
  version = "0.1.4"
}

provider "kubernetes" {}

resource "kubernetes_cluster_role" "tfc_agent_role" {
  metadata {
    name = "terraform-cloud-agent"
  }

  rule {
    api_groups = ["", "apps", "autoscaling", "batch", "extensions", "policy", "rbac.authorization.k8s.io"]
    resources  = ["componentstatuses", "configmaps", "daemonsets", "deployments", "events", "endpoints", "horizontalpodautoscalers", "ingress", "jobs", "limitranges", "namespaces", "nodes", "pods", "persistentvolumes", "persistentvolumeclaims", "resourcequotas", "replicasets", "replicationcontrollers", "serviceaccounts", "services"]
    verbs      = ["*"]
  }
}

resource "kubernetes_service_account" "tfc_agent_service_account" {
  metadata {
    name      = "terraform-cloud-agent"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "tfc_agent_cluster_role_binding" {
  metadata {
    name = "terraform-cloud-agent"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tfc_agent_role.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tfc_agent_service_account.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_secret" "tfc_agent_token" {
  metadata {
    name      = "tfc-agent-token"
    namespace = var.namespace
  }

  data = {
    "token" = var.agent_token_secret
  }
}

resource "kubernetes_config_map" "tfc_agent_configuration" {
  metadata {
    name      = "tfc-agent-configuration"
    namespace = var.namespace
  }

  data = {
    name           = var.agent_token_name
    url            = var.tfc_url
    log-level      = var.agent_log_level
    disable-update = tostring(var.agent_disable_update)
  }
}

resource "kubernetes_deployment" "tfc_agent" {
  metadata {
    name      = "terraform-cloud-agent"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "terraform-cloud-agent-deployment"
      "app.kubernetes.io/version"    = local.version
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name"       = "terraform-cloud-agent"
        "app.kubernetes.io/version"    = local.version
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"       = "terraform-cloud-agent"
          "app.kubernetes.io/version"    = local.version
          "app.kubernetes.io/managed-by" = "terraform"
        }
      }

      spec {
        container {
          image = "hashicorp/tfc-agent:${local.version}"
          name  = "terraform-cloud-agent"

          #   resources {
          #     requests {
          #       cpu    = "2000m"
          #       memory = "2Gi"
          #     }
          #     limits {
          #       cpu    = "8000m"
          #       memory = "8Gi"
          #     }
          #   }

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
            name = "TFC_AGENT_DISABLE_UPDATE"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.tfc_agent_configuration.metadata[0].name
                key  = "disable-update"
              }
            }
          }
        }
        automount_service_account_token = true
        service_account_name            = kubernetes_service_account.tfc_agent_service_account.metadata[0].name
      }
    }
  }
}