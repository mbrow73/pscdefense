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
    apt-get update && apt-get install -y curl ca-certificates

    # Install the CA certificate for TLS inspection
    cat << CERT > /usr/local/share/ca-certificates/inspection-ca.crt
    ${google_privateca_certificate_authority.default.pem_ca_certificate}
    CERT

    # Update the OS trust store
    update-ca-certificates

    # Test connectivity to the PSC endpoint
    while true; do
      curl -s -o /dev/null -w "HTTP Code: %%{http_code}\n" https://${var.psc_endpoint_ip} || echo "Request failed"
      sleep 10
    done
  EOF

  tags = ["lab-client"]
}
