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

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y curl
    while true; do
      curl -s -o /dev/null -w "HTTP Code: %%{http_code}\n" https://${var.psc_endpoint_ip} || echo "Request failed"
      sleep 10
    done
  EOF

  tags = ["lab-client"]
}
