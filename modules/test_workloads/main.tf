// Deploy an internal client VM to generate traffic.
resource "google_compute_instance" "internal_client" {
  name         = "lab-internal-client"
  project      = var.project_id
  zone         = var.zone
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}

## pub service provider ##

resource "google_compute_instance" "backend_service" {
  name         = "backend-service-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.network
    subnetwork = "projects/psc-security-lab/regions/us-central1/subnetworks/default"
    access_config {
      # Ephemeral IP
    }
  }

  tags = ["http-server"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOF
}