output "psc_forwarding_rule_ip" {
  value = google_compute_global_forwarding_rule.psc_forwarding_rule.ip_address
}

output "psc_neg_self_link" {
  value = google_compute_region_network_endpoint_group.psc_neg.self_link
}
