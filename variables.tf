variable "agent_token_name" {
  type        = string
  description = "The TFC agent token description defined in TFC at app/<org>/settings/agents."
}

variable "agent_token_secret" {
  type        = string
  description = "The TFC agent token secret generated when the agent was created."
}

variable "tfc_url" {
  type        = string
  default     = "https://app.terraform.io"
  description = "The Terraform Cloud endpoint.  Must be changed if using Terraform Enterprise."
}

variable "agent_log_level" {
  type        = string
  default     = "error"
  description = "Available log levels are info, error, warn, debug, and trace."
}

variable "agent_disable_update" {
  type        = bool
  default     = true
  description = "Agents will self-update if set to false."
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the agent into.  Unless create_namespace is true, the namespace must already exist."
}

variable "cluster_access" {
  type        = bool
  default     = false
  description = "When true, provides the agent access to the cluster to manage Kubernetes resources."
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "When true, creates the namespace for the Terraform Cloud Agent."
}