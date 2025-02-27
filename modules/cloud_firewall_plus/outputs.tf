output "firewall_policy_id" {
  value = google_compute_firewall_policy.lab_firewall_policy.id
}

output "ca_private_key_pem" {
  value = google_privateca_certificate_authority.default.pem_ca_certificates
  
}