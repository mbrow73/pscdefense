// Create a new GCP project for the lab.
resource "google_project" "lab_project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
}

// Create a Shared VPC network.
resource "google_compute_network" "lab_network" {
  name                    = var.network_name
  project                 = google_project.lab_project.project_id
  auto_create_subnetworks = false
}

// Create a subnet within the network.
resource "google_compute_subnetwork" "lab_subnet" {
  name          = var.subnet_name
  project       = google_project.lab_project.project_id
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.lab_network.self_link
}

// Enable required APIs.
resource "google_project_service" "compute_api" {
  project = google_project.lab_project.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "servicenetworking_api" {
  project = google_project.lab_project.project_id
  service = "servicenetworking.googleapis.com"
}
