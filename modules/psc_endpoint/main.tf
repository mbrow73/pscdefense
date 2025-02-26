# Reserve an internal IP for the PSC endpoint
# modules/psc_endpoint/main.tf

# Reserve global INTERNAL address for PSC
resource "google_compute_global_address" "psc_vip" {
  name          = "psc-vip"
  project       = var.project_id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  address_type  = "INTERNAL"
  network       = var.network
}

# PSC Forwarding Rule
resource "google_compute_global_forwarding_rule" "psc_forwarding_rule" {
  name                  = var.psc_name
  project               = var.project_id
  load_balancing_scheme = ""  # Must be empty for direct PSC
  target                = "vpc-sc"
  network               = var.network
  ip_address            = google_compute_global_address.psc_vip.address
  port_range            = "443"
}

