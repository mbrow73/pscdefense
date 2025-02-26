variable "project_id" {
  description = "Project ID for Traffic Director."
  type        = string
}

variable "region" {
  description = "Region for Traffic Director resources."
  type        = string
  default     = "us-central1"
}

variable "td_backend_name" {
  description = "Name for the Traffic Director backend service."
  type        = string
  default     = "lab-td-backend"
}

variable "psc_neg" {
  description = "Self-link of the PSC NEG from the psc_endpoint module."
  type        = string
}

variable "td_url_map_name" {
  description = "Name for the Traffic Director URL map."
  type        = string
  default     = "lab-td-url-map"
}

variable "td_target_proxy_name" {
  description = "Name for the Traffic Director target HTTPS proxy."
  type        = string
  default     = "lab-td-target-proxy"
}

variable "ssl_certificate" {
  description = "SSL certificate resource self-link for HTTPS termination."
  type        = string
  default     = ""  // Replace with your certificate resource self-link.
}
