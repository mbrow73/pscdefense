
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

// Enable required APIs.
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "servicenetworking_api" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}
