variable "agent_token" {
  type        = string
  description = "The TFC agent token generated when the agent was created."
  sensitive   = true
}
variable "agent_version" {
  type        = string
  default     = "latest"
  description = "Version of the Terraform Cloud Agent docker image."
}
