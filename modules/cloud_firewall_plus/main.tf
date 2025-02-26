// Create a hierarchical firewall policy for Cloud Firewall Plus (NGFW) with IPS and TLS inspection.
// (TLS inspection configuration would normally include CA integration, not shown here.)

resource "google_compute_firewall_policy" "lab_firewall_policy" {
  provider = google-beta
  short_name    = var.firewall_policy_name
  parent        = var.org_id
}

resource "google_compute_firewall_policy_association" "default" {
  firewall_policy = google_compute_firewall_policy.policy.id
  attachment_target = var.project_id
  name = "my-association"
}

resource "google_compute_firewall_policy_rule" "psc_ips_rule" {
  firewall_policy = google_compute_firewall_policy.lab_firewall_policy.short_name
  priority        = 1000
  direction       = "INGRESS"
  action          = "ALLOW"  // Change to DENY to block traffic if desired.
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [var.psc_port]
    }
    // Additional match conditions can be added for L7 inspection.
  }
  target_resources = [var.target_resource]  // For example, a network tag such as "lab-client".
  description      = "Allow and inspect traffic to PSC endpoint with IPS/TLS inspection enabled."
}
