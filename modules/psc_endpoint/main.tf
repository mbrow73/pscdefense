# Reserve an internal IP for the PSC endpoint
resource "google_compute_address" "psc_ip" {
  name          = "psc-internal-ip"
  project       = var.project_id
  region        = var.region
  subnetwork    = var.subnetwork
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"  # Critical for PSC
}

# Create the PSC Forwarding Rule
resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name       = var.psc_name
  project    = var.project_id
  region     = var.region
  network    = var.network
  subnetwork = var.subnetwork
  ip_address = google_compute_address.psc_ip.address

  # Required fields (set explicitly)
  load_balancing_scheme = "INTERNAL"          # Must be empty for PSC to Google APIs
  target                = "storage.googleapis.com"  # Directly specify the Google API
  port_range            = "443"       # Port for HTTPS
  ip_protocol           = "TCP"
}