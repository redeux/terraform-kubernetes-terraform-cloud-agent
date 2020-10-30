resource "kubernetes_cluster_role" "tfc_agent_role" {
  count = var.cluster_access ? 1 : 0

  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }

    name = "terraform-cloud-agent"
  }

  rule {
    api_groups = ["", "apps", "autoscaling", "batch", "extensions", "policy", "rbac.authorization.k8s.io"]
    resources  = ["componentstatuses", "configmaps", "daemonsets", "deployments", "events", "endpoints", "horizontalpodautoscalers", "ingress", "jobs", "limitranges", "namespaces", "nodes", "pods", "persistentvolumes", "persistentvolumeclaims", "resourcequotas", "replicasets", "replicationcontrollers", "serviceaccounts", "services"]
    verbs      = ["*"]
  }
}