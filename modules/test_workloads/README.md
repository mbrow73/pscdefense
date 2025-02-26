output "internal_client_ip" {
  value = google_compute_instance.internal_client.network_interface[0].access_config[0].nat_ip
}

output "onprem_client_ip" {
  value = google_compute_instance.onprem_client[0].network_interface[0].access_config[0].nat_ip
}
