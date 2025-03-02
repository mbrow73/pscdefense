output "internal_client_ip" {
  value = google_compute_instance.internal_client.network_interface[0].access_config[0].nat_ip
}

output "backend_service_id" {
  value = google_compute_instance.backend_service.id
}