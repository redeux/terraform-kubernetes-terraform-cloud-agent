variable "agent_disable_update" {
  type        = bool
  default     = true
  description = "Agents will self-update if set to false."
}

variable "agent_image" {
  type        = string
  default     = "hashicorp/tfc-agent"
  description = "Name of the Terraform Cloud Agent docker image."
}

variable "agent_log_level" {
  type        = string
  default     = "error"
  description = "Available log levels are info, error, warn, debug, and trace."
}

variable "agent_name" {
  type        = string
  description = "The TFC agent token description defined in TFC at app/<org>/settings/agents."
}

variable "agent_replicacount" {
  type        = number
  default     = 1
  description = "Replicacount of the terraform cloud agent deployment."
}

variable "agent_token" {
  type        = string
  description = "The TFC agent token generated when the agent was created."
}

variable "agent_version" {
  type        = string
  default     = "latest"
  description = "Version of the Terraform Cloud Agent docker image."
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

variable "limits_cpu" {
  type        = string
  default     = "1000m"
  description = "CPU hard limits."
}

variable "limits_memory" {
  type        = string
  default     = "1Gb"
  description = "Memory hard limits."
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the agent into.  Unless create_namespace is true, the namespace must already exist."
}

variable "requests_cpu" {
  type        = string
  default     = "1"
  description = "CPU requests."
}

variable "requests_memory" {
  type        = string
  default     = "1Gb"
  description = "Memory requests."
}

variable "tfc_url" {
  type        = string
  default     = "https://app.terraform.io"
  description = "The Terraform Cloud endpoint.  Must be changed if using Terraform Enterprise."
}

