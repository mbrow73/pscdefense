
// Traffic Director configuration for inline L7 control via an Envoy-based proxy.
// This example creates an internal HTTPS backend service that uses a PSC NEG.

resource "google_compute_region_backend_service" "td_backend" {
  name                    = var.td_backend_name
  project                 = var.project_id
  region                  = var.region
  protocol                = "HTTPS"
  load_balancing_scheme   = "INTERNAL_MANAGED"
  timeout_sec             = 30

  backend {
    group = var.psc_neg
  }
}

resource "google_compute_region_url_map" "td_url_map" {
  name           = var.td_url_map_name
  project        = var.project_id
  default_service = google_compute_region_backend_service.td_backend.self_link
}

resource "google_compute_region_target_https_proxy" "td_target_https_proxy" {
  name            = var.td_target_proxy_name
  project         = var.project_id
  region          = var.region
  url_map         = google_compute_region_url_map.td_url_map.self_link
  ssl_certificates = [var.ssl_certificate]
}
