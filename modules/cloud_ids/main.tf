resource "google_cloud_ids_endpoint" "cloud_ids" {
  name     = var.ids_name
  location = var.ids_location    // e.g. "us-central1-f"
  network  = var.network         // network self_link, e.g. from network module
  severity = "INFORMATIONAL"
  project  = var.project_id
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
    url = google_compute_forwarding_rule.collector_ilb.self_link
  }
  
  filter {
    cidr_ranges = [var.psc_endpoint_ip]
  }
}


## instance group for the collector ##
resource "google_compute_instance_template" "collector_template" {
  name         = "collector-template"
  project      = var.project_id
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }
}

resource "google_compute_instance_group_manager" "collector_igm" {
  version {
    instance_template = google_compute_instance_template.collector_template.self_link
  }
  name               = "collector-igm"
  project            = var.project_id
  zone               = var.zone
  base_instance_name = "collector-instance"
  target_size        = 1
}

## BE service for the collector ##

resource "google_compute_backend_service" "collector_backend" {
  name                  = "collector-backend"
  project               = var.project_id
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  timeout_sec           = 30

  backend {
    group = google_compute_instance_group_manager.collector_igm.instance_group
  }
}

## Forwarding rule for the collector ##

resource "google_compute_forwarding_rule" "collector_ilb" {
  name                  = "collector-ilb"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = var.network
  subnetwork            = var.subnetwork
  ip_protocol           = "TCP"
  ports                 = ["80"]
  target                = google_compute_backend_service.collector_backend.self_link
}
