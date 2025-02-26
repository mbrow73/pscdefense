// Create a Shared VPC network.
resource "google_compute_network" "lab_network" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

// Create a subnet within the network.
resource "google_compute_subnetwork" "lab_subnet" {
  name          = var.subnet_name
  project       = var.project_id
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.lab_network.self_link
}
resource "google_compute_subnetwork" "psc_subnet" {
  name          = "psc-subnet"
  ip_cidr_range = "10.10.1.0/24" # New CIDR not overlapping with existing subnets
  network       = google_compute_network.lab_network.self_link
  region        = "us-central1"
  project       = var.project_id
}

// Enable required APIs.
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "servicenetworking_api" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}
