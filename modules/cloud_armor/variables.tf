variable "project_id" {
  description = "Project ID for Cloud Armor policy."
  type        = string
  default     ="psc-security-lab"
}

variable "security_policy_name" {
  description = "Name for the Cloud Armor security policy."
  type        = string
  default     = "lab-armor-policy"
}
