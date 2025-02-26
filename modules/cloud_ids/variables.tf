variable "ids_name" {
  description = "Name for the Cloud IDS endpoint."
  type        = string
}

variable "ids_location" {
  description = "Location for the Cloud IDS endpoint (e.g. 'us-central1-f')."
  type        = string
  default     = "us-central1-f"
}

variable "network" {
  description = "The network self_link in which to deploy Cloud IDS and packet mirroring."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork self_link in which to deploy packet mirroring."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork (used in the mirrored_resources block)."
  type        = string
}

variable "region" {
  description = "Region for Cloud IDS and Packet Mirroring."
  type        = string
}

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "psc_endpoint_ip" {
  description = "The PSC endpoint IP address to filter mirrored traffic."
  type        = string
}
