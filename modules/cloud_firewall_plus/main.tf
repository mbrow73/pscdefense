// Create a hierarchical firewall policy for Cloud Firewall Plus (NGFW) with IPS and TLS inspection.
// (TLS inspection configuration would normally include CA integration, not shown here.)

resource "google_compute_firewall_policy" "lab_firewall_policy" {
  provider = google-beta
  short_name    = var.firewall_policy_name
  parent        = "organizations/866579528862"
}

resource "google_compute_firewall_policy_association" "default" {
  firewall_policy = google_compute_firewall_policy.lab_firewall_policy.id
  attachment_target = "projects/psc-security-lab/global/networks/lab-shared-vpc"
  name = "my-association"
}

resource "google_compute_firewall_policy_rule" "psc_ips_rule" {
  firewall_policy = google_compute_firewall_policy.lab_firewall_policy.id
  priority        = 1000
  direction       = "INGRESS"
  action          = "apply_security_profile_group"
  tls_inspect     ="true"
  security_profile_group = google_network_security_security_profile_group.default.id
  match {
    src_ip_ranges = ["0.0.0.0/0"]
    dest_ip_ranges = ["0.0.0.0/0"]
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [var.psc_port]
    }
    
  }
  description      = "Allow and inspect traffic to PSC endpoint with IPS/TLS inspection enabled."
}


## sec profile ##
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
}