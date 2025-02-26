output "cloud_ids_endpoint_id" {
  description = "ID of the deployed Cloud IDS endpoint."
  value       = google_cloud_ids_endpoint.cloud_ids.id
}
