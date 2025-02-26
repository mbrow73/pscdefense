variable "ids_name" {
  description = "Name for the Cloud IDS endpoint."
  type        = string
  default     = "lab-cloud-ids"
}

variable "ids_location" {
  description = "Location for the Cloud IDS endpoint (e.g., 'us-central1-f')."
  type        = string
  default     = "us-central1-f"
}

variable "project_name" {
  description = "Name for the lab project."
  type        = string
}

variable "project_id" {
  description = "Project ID for the lab project."
  type        = string
}

variable "org_id" {
  description = "Organization ID or folder."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID."
  type        = string
}

variable "network_name" {
  description = "Name for the Shared VPC network."
  type        = string
  default     = "lab-shared-vpc"
}

variable "subnet_name" {
  description = "Name for the subnet."
  type        = string
  default     = "lab-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "psc_name" {
  description = "Name for the PSC endpoint."
  type        = string
  default     = "lab-psc-endpoint"
}

variable "psc_port" {
  description = "Port for the PSC endpoint."
  type        = string
  default     = "443"
}

variable "psc_neg_name" {
  description = "Name for the PSC NEG."
  type        = string
  default     = "lab-psc-neg"
}

variable "target_service" {
  description = "Target service attachment for PSC (Google-managed)."
  type        = string
  default     = "projects/google-managed-service/global/backendServices/default"
}

variable "firewall_policy_name" {
  description = "Name for the Cloud Firewall Plus policy."
  type        = string
  default     = "lab-firewall-policy"
}

variable "target_resource" {
  description = "Target resource tag for the firewall rule."
  type        = string
  default     = "lab-client"
}

variable "security_policy_name" {
  description = "Name for the Cloud Armor security policy."
  type        = string
  default     = "lab-armor-policy"
}

variable "td_backend_name" {
  description = "Name for the Traffic Director backend service."
  type        = string
  default     = "lab-td-backend"
}

variable "td_url_map_name" {
  description = "Name for the Traffic Director URL map."
  type        = string
  default     = "lab-td-url-map"
}

variable "td_target_proxy_name" {
  description = "Name for the Traffic Director target proxy."
  type        = string
  default     = "lab-td-target-proxy"
}

variable "ssl_certificate" {
  description = "SSL certificate resource self-link for Traffic Director HTTPS termination."
  type        = string
  default     = ""
}

variable "ids_name" {
  description = "Name for the Cloud IDS endpoint."
  type        = string
  default     = "lab-cloud-ids"
}

variable "zone" {
  description = "GCP zone for test workloads."
  type        = string
  default     = "us-central1-a"
}

variable "onprem_network" {
  description = "Network self link for on-prem simulation. Leave empty if not used."
  type        = string
  default     = ""
}

variable "onprem_subnetwork" {
  description = "Subnetwork self link for on-prem simulation. Leave empty if not used."
  type        = string
  default     = ""
}

variable "controllerproject"{
  description = "Subnetwork self link for on-prem simulation. Leave empty if not used."
  type        = string
  default     = "testautomation-451116"
}

variable "GOOGLE_CREDENTIALS" {
  description = "Subnetwork self link for on-prem simulation. Leave empty if not used."
  type        = string
}
