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

resource "google_compute_global_address" "private_service_access" {
  name          = "psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.lab_network.self_link  // the network self_link
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.lab_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access.name]
}