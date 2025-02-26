variable "project_id" {
  description = "Project ID for test workloads."
  type        = string
    default     = "psc-security-lab"
}

variable "zone" {
  description = "GCP zone for the test VM instance."
  type        = string
  default     = "us-central1-a"
}

variable "network" {
  description = "Network self link for internal client (from network module)."
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork self link for internal client (from network module)."
  type        = string
}

variable "onprem_network" {
  description = "Network self link simulating on-prem client."
  type        = string
  default     = ""
}

variable "onprem_subnetwork" {
  description = "Subnetwork self link for on-prem client simulation."
  type        = string
  default     = ""
}

variable "psc_endpoint_ip" {
  description = "PSC endpoint IP address from psc_endpoint module."
  type        = string
}
