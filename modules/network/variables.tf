variable "project_name" {
  description = "Name for the new GCP lab project"
  type        = string
}

variable "project_id" {
  description = "Project ID for the new GCP lab project"
  type        = string
}

variable "org_id" {
  description = "Organization ID or folder where the project will be created"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID to be associated with the project"
  type        = string
}

variable "network_name" {
  description = "Name of the Shared VPC network"
  type        = string
  default     = "lab-shared-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "lab-subnet"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "region" {
  description = "Region for the subnet"
  type        = string
  default     = "us-central1"
}
