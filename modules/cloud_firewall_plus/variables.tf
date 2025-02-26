variable "project_id" {
  description = "Project ID for firewall policy creation."
  type        = string
}

variable "firewall_policy_name" {
  description = "Name for the hierarchical firewall policy."
  type        = string
  default     = "lab-firewall-policy"
}

variable "psc_port" {
  description = "Port for the PSC endpoint, used in firewall rule matching."
  type        = string
  default     = "443"
}

variable "target_resource" {
  description = "Target resource identifier (e.g., network tag) for the firewall rule to apply."
  type        = string
  default     = "lab-client"
}
