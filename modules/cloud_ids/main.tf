resource "google_cloud_ids_endpoint" "cloud_ids" {
  name     = var.ids_name
  location = var.ids_location    // e.g. "us-central1-f"
  network  = var.network         // network self_link, e.g. from network module
  severity = "INFORMATIONAL"
  project  = var.project_id
}

resource "google_compute_forwarding_rule" "ids_collector_ilb" {
  name                  = "lab-ids-collector"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = var.network
  subnetwork            = var.subnetwork
  ip_protocol           = "TCP"
  ports                 = ["80"]
}

resource "google_compute_packet_mirroring" "psc_packet_mirroring" {
  name   = "lab-psc-mirroring"
  region = var.region

  mirrored_resources {
    subnetworks {
      url = var.subnetwork
    }
  }

  network {
    url = var.network
  }
  
  collector_ilb {
    url = google_compute_forwarding_rule.ids_collector_ilb.self_link
  }
  
  filter {
    cidr_ranges = [var.psc_endpoint_ip]
  }
}
