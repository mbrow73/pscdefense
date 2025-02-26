output "lab_project_id" {
  value = google_project.lab_project.project_id
}

output "network_self_link" {
  value = google_compute_network.lab_network.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.lab_subnet.self_link
}
