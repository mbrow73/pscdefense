variable "project_id" {
  description = "Project ID where the PSC endpoint is created"
  type        = string
  default = "psc-security-lab"
}

variable "network" {
  description = "Network self link (from network module)"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork self link (from network module)"
  type        = string
}

variable "region" {
  description = "Region for the PSC endpoint"
  type        = string
  default     = "us-central1"
}

variable "psc_name" {
  description = "Name for the PSC forwarding rule"
  type        = string
  default     = "lab-psc-endpoint"
}

variable "psc_port" {
  description = "Port for the PSC endpoint"
  type        = string
  default     = "443"
}

variable "psc_neg_name" {
  description = "Name for the PSC Network Endpoint Group"
  type        = string
  default     = "lab-psc-neg"
}

variable "target_service" {
  description = "Target service attachment self link (Google-managed service) for PSC."
  type        = string
  default     = "projects/servicenetworking/global/serviceAttachments/servicenetworking-googleapis-com"
}
