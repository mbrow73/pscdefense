resource "google_compute_security_policy" "lab_armor_policy" {
  name        = var.security_policy_name
  description = "Cloud Armor security policy for lab PSC endpoint"
  project     = var.project_id
  type = "CLOUD_ARMOR"

  rule {
    priority    = 1000
    description = "Block malicious requests (example SQL injection)"
    match {
      versioned_expr = "SRC_IPS_V1" // This is an example; adjust based on your needs.
      config {
        src_ip_ranges = ["*"]
      }
    }
    action = "deny(403)"
  }
}
