// Create a PSC forwarding rule to a Google-managed service.
// (This example uses an INTERNAL_MANAGED load balancing scheme.)
resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name                  = var.psc_name
  project               = var.project_id
  region                = var.region  # Specify the region
  load_balancing_scheme = "INTERNAL"  # Correct scheme for PSC
  network               = var.network
  subnetwork            = var.subnetwork
  target                = google_compute_region_network_endpoint_group.psc_neg.self_link
  ip_protocol           = "TCP"
}


resource "google_compute_region_network_endpoint_group" "psc_neg" {
  name                  = var.psc_neg_name
  project               = var.project_id
  region                = var.region
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = "storage.googleapis.com"
}


resource "google_compute_global_address" "private_service_access" {
  name          = "psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network  // the network self_link
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access.name]
}
