# variables.tf
variable "psc_name" {
  description = "Name for the PSC forwarding rule"
  type        = string
  default     = "psc-storage-endpoint"
}

variable "project_id" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "region" {
  type = string
}