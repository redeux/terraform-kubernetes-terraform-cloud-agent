# terraform-cloud-agent-kubernetes
A Terraform module for deploying the Terraform Cloud for Business Agent in Kubernetes

**Note**: This is a community module and is not supported by HashiCorp.

## Inputs
### Required
**agent_token_name**: The TFC agent token description defined in TFC at app/\<org>/settings/agents.

**agent_token_secret**: The TFC agent token secret generated when the agent was created.

**namespace**: The namespace to deploy the agent into.  The namespace must already exist.

### Optional
**tfc_url**: The Terraform Cloud endpoint.  Must be changed if using Terraform Enterprise.

**agent_log_level**: Available log levels are info, error, warn, debug, and trace. Defaults to error.

**agent_disable_update**: Agents will self-update if set to false. Defaults to true.

**cluster_access**: When true, provides the agent access to the cluster to manage Kubernetes resources. Defaults to false.

**create_namespace**: When true, creates the namespace for the Terraform Cloud Agent. Defaults to false

## Example
```hcl
provider "kubernetes" {}

module "terraform-cloud-agent-kubernetes" {
  source  = "redeux/terraform-cloud-agent/kubernetes"
  version = "0.0.1"

  namespace          = "terraform-cloud-agent"
  create_namespace   = true
  agent_token_name   = "example-agent"
  agent_token_secret = "myagent.atlasv1.secrettoken"
  cluster_access     = true
}
```