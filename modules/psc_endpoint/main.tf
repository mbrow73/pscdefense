# Reserve an internal IP for the PSC endpoint
# modules/psc_endpoint/main.tf

# Reserve global INTERNAL address for PSC
resource "google_compute_global_address" "psc_vip" {
  name          = "psc-vip"
  project       = var.project_id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  address_type  = "INTERNAL"
  network       = var.network
  address       = "10.2.2.1"
}
# reserve a private internal address for published service psc-endpoint.
resource "google_compute_address" "psc_endpoint" {
  project       = var.project_id
  name          = "psc-endpoint"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  address_type  = "INTERNAL"
  network       = var.network
  address       = "10.2.2.2"
  region        = "us-central1"
}

# PSC Forwarding Rule APIs
resource "google_compute_global_forwarding_rule" "psc_forwarding_rule" {
  name                  = "googleapispsc"
  project               = var.project_id
  load_balancing_scheme = ""  # Must be empty for direct PSC
  target                = "vpc-sc"
  network               = var.network
  ip_address            = google_compute_global_address.psc_vip.address
}

resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  project               = var.project_id
  name                  = "psc-forwarding-rule"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_backend_bucket.storage_backend.self_link
  network               = var.network
  subnetwork            = "psc-subnet"
}

resource "google_compute_backend_bucket" "storage_backend" {
  name        = "storage-backend"
  bucket_name = "storage-backend"
  enable_cdn  = false
  project     = var.project_id
}