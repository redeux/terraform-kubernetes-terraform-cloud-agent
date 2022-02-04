
module "terraform-cloud-agent-kubernetes" {
  source  = "redeux/terraform-cloud-agent/kubernetes"
  version = "0.1.0"
  namespace          = "terraform-cloud-agent"
  create_namespace   = true
  agent_name         = "example-agent"
  agent_token        = var.agent_token
  cluster_access     = true
}
