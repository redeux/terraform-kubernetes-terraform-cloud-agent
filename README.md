# terraform-cloud-agent-kubernetes
A Terraform module for deploying the Terraform Cloud for Business Agent in Kubernetes


```hcl
provider "kubernetes" {}

module "terraform-cloud-agent-kubernetes" {
  source  = "github.com/redeux/terraform-cloud-agent-kubernetes"
  version = "0.0.1"

  namespace          = "agent"
  create_namespace   = true
  agent_token_name   = "example-agent"
  agent_token_secret = "myagent.atlasv1.secrettoken"
  cluster_access     = true
}
```