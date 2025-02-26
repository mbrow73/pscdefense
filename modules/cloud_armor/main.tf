resource "google_compute_security_policy" "lab_armor_policy" {
  name        = var.security_policy_name
  description = "Cloud Armor security policy for lab PSC endpoint"
  project     = var.project_id
  type = "CLOUD_ARMOR"


  rule {
    priority    = 1000
    action      = "deny(403)"
    description = "Block SQL injection attempts"
    match {
      versioned_expr = "PRECONFIGURED_WAF"
      config {
        src_ip_ranges= ["*"]
        }
      }
    }

  rule {
    priority    = 1001
    action      = "allow"
    description = "Block SQL injection attempts"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
        }
      }
    }

rule {
  description     = "default rule"
  action          = "deny"
  priority        = "2147483647"
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
    }
  }
}
}


