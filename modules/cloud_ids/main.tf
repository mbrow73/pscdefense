# Cloud IDS Endpoint
resource "google_cloud_ids_endpoint" "cloud_ids" {
  name     = var.ids_name
  location = var.ids_location  # Must be a zone (e.g., "us-central1-f")
  network  = var.network
  severity = "INFORMATIONAL"
  project  = var.project_id
}

# Packet Mirroring to Collector ILB
resource "google_compute_packet_mirroring" "psc_packet_mirroring" {
  name   = "lab-psc-mirroring"
  region = var.region  # Must match the region of subnetwork/ILB

  mirrored_resources {
    subnetworks {
      url = var.subnetwork  # Subnetwork to mirror traffic from
    }
  }

  network {
    url = var.network  # Network where mirrored traffic resides
  }

  collector_ilb {
    # Target the INTERNAL TCP Load Balancer (L4)
    url = google_compute_forwarding_rule.collector_ilb.self_link
  }

  filter {
    cidr_ranges = [var.psc_endpoint_ip]  # IP range to mirror
  }
}

# Instance Template for Collector
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
    # Assign a static internal IP if needed
  }

  # Install and configure your collector software here (e.g., via startup script)
  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx  # Example: Install a service to receive traffic
  EOF
}

# Instance Group for Collector
resource "google_compute_instance_group_manager" "collector_igm" {
  name               = "collector-igm"
  project            = var.project_id
  zone               = var.zone  # Zone must match the instance template's region
  base_instance_name = "collector-instance"
  target_size        = 1

  version {
    instance_template = google_compute_instance_template.collector_template.self_link
  }
}

# Backend Service for Collector (TCP L4)
resource "google_compute_region_backend_service" "collector_backend" {
  name                  = "collector-backend"
  project               = var.project_id
  region                = var.region  # Must match packet mirroring region
  protocol              = "TCP"  # Use TCP for L4 load balancing
  load_balancing_scheme = "INTERNAL"  # L4 Internal Load Balancer
  health_checks         = [google_compute_health_check.collector_health_check.self_link]

  backend {
    group = google_compute_instance_group_manager.collector_igm.instance_group
  }
}

# Health Check for Collector (TCP)
resource "google_compute_health_check" "collector_health_check" {
  name               = "collector-health-check"
  project            = var.project_id
  check_interval_sec = 30
  timeout_sec        = 10

  tcp_health_check {
    port = 80  # Port your collector listens on (e.g., 80 for HTTP, 443 for HTTPS)
  }
}

# Forwarding Rule for Collector (Internal TCP Load Balancer)
resource "google_compute_forwarding_rule" "collector_ilb" {
  name                  = "collector-ilb"
  project               = var.project_id
  region                = var.region  # Must match backend service region
  load_balancing_scheme = "INTERNAL"  # L4 Load Balancer
  backend_service       = google_compute_region_backend_service.collector_backend.self_link
  network               = var.network
  subnetwork            = var.subnetwork
  ip_protocol           = "TCP"
  ports                 = [80]  # Port(s) your collector listens on
}