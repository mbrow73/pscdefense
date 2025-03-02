// Create a hierarchical firewall policy for Cloud Firewall Plus (NGFW) with IPS and TLS inspection.
// (TLS inspection configuration would normally include CA integration, not shown here.)

resource "google_compute_firewall_policy" "lab_firewall_policy" {
  provider = google-beta
  short_name    = var.firewall_policy_name
  parent        = "organizations/866579528862"
}

resource "google_compute_firewall_policy_association" "default" {
  firewall_policy = google_compute_firewall_policy.lab_firewall_policy.id
  attachment_target = "organizations/866579528862"
  name = "my-association"
}

resource "google_compute_firewall_policy_rule" "psc_ips_rule" {
  firewall_policy = google_compute_firewall_policy.lab_firewall_policy.id
  priority        = 1000
  direction       = "EGRESS"
  action          = "apply_security_profile_group"
  tls_inspect     ="true"
  security_profile_group = google_network_security_security_profile_group.default.id
  match {
    src_ip_ranges = ["10.10.0.0/24"]
    dest_ip_ranges = ["10.2.2.1/32"]
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [var.psc_port]
    }
    
  }
  description      = "Allow and inspect traffic to PSC endpoint with IPS/TLS inspection enabled."
}

## CA / POOL ##
resource "google_privateca_certificate_authority" "default" {
  // This example assumes this pool already exists.
  // Pools cannot be deleted in normal test circumstances, so we depend on static pools
  pool = google_privateca_ca_pool.tls_ca_pool.name  # Use the CA pool's NAME, not ID
  certificate_authority_id = "my-certificate-authority"
  location = "us-central1"
  deletion_protection = true
  project = var.project_id
  config {
    subject_config {
      subject {
        organization = "ACME"
        common_name = "my-certificate-authority"
      }
    }
    x509_config {
      ca_options {
        # is_ca *MUST* be true for certificate authorities
        is_ca = true
      }
      key_usage {
        base_key_usage {
          # cert_sign and crl_sign *MUST* be true for certificate authorities
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
        }
      }
    }
  }
  # valid for 10 years
  lifetime = "${10 * 365 * 24 * 3600}s"
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
}
resource "google_privateca_ca_pool" "tls_ca_pool" {
  project = var.project_id
  name     = "tls-ca-pool"
  location = "us-central1"
  tier     = "DEVOPS"  # Use "ENTERPRISE" for production
  publishing_options {
    publish_ca_cert = true
    publish_crl     = false
  }
}

## INSPECTION POLICY ##

resource "google_network_security_tls_inspection_policy" "tls_inspection_policy" {
  name        = "tls-inspection-policy"
  location    = "us-central1"
  ca_pool     = google_privateca_ca_pool.tls_ca_pool.id  # Reference your CA pool
  description = "TLS inspection policy for PSC traffic"
  project     = var.project_id
}


## sec profiles ##
resource "google_network_security_security_profile" "default" {
  name        = "my-security-profile"
  parent      = "organizations/866579528862"
  description = "L7 inspection"
  type        = "THREAT_PREVENTION"
  }



## sec profile group ##
resource "google_network_security_security_profile_group" "default" {
  name                      = "sec-profile-group"
  parent                    = "organizations/866579528862"
  description               = "my description"
  threat_prevention_profile = google_network_security_security_profile.default.id
}

## FW endpoint ##

resource "google_network_security_firewall_endpoint" "default" {
  name               = "my-firewall-endpoint"
  parent             = "organizations/866579528862"
  location           = "us-central1-a"
  billing_project_id = var.project_id
}

## Endpint Association ##

resource "google_network_security_firewall_endpoint_association" "default_association" {
  name              = "my-firewall-endpoint-association"
  parent            = "projects/psc-security-lab"
  location          = "us-central1-a"
  network           = "projects/psc-security-lab/global/networks/lab-shared-vpc"
  firewall_endpoint = google_network_security_firewall_endpoint.default.id
  disabled          = false
  tls_inspection_policy = google_network_security_tls_inspection_policy.tls_inspection_policy.id
}

## provider http rule ##

resource "google_compute_firewall" "allow_psc_to_backend" {
  name    = "allow-psc-to-backend"
  project = var.project_id
  network = "psc-security-lab"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["10.2.2.3/32"]  # PSC endpoint IP
  target_tags   = ["http-server"]  # Tags on the backend instance
}