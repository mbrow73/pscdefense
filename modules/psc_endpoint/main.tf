// Create a PSC forwarding rule to a Google-managed service.
// (This example uses an INTERNAL_MANAGED load balancing scheme.)
resource "google_compute_global_forwarding_rule" "psc_forwarding_rule" {
  name                  = var.psc_name
  project               = var.project_id
  load_balancing_scheme = "GLOBAL"
  network               = var.network
  subnetwork            = var.subnetwork
  target                = var.target_service
  ip_protocol           = "TCP"
}

// Optionally, create a PSC Network Endpoint Group (NEG) for more control.
resource "google_compute_region_network_endpoint_group" "psc_neg" {
  name                  = var.psc_neg_name
  project               = var.project_id
  region                = var.region
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
}
