# Reserve an internal IP for the PSC endpoint
# modules/psc_endpoint/main.tf

# Reserve global INTERNAL address for PSC
resource "google_compute_global_address" "psc_vip" {
  name          = "psc-vip"
  project       = var.project_id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  address_type  = "INTERNAL"
  network       = var.network
  address       = "10.2.2.1"
}
# reserve a private internal address for published service psc-endpoint.
#resource "google_compute_global_address" "psc_endpoint" {
#  project       = var.project_id
#  name          = "psc-endpoint"
#  purpose       = "PRIVATE_SERVICE_CONNECT"
#  address_type  = "INTERNAL"
#  network       = var.network
#  address       = "10.2.2.2"
#}

# PSC Forwarding Rule APIs
resource "google_compute_global_forwarding_rule" "psc_forwarding_rule" {
  name                  = "googleapispsc"
  project               = var.project_id
  load_balancing_scheme = ""  # Must be empty for direct PSC
  target                = "vpc-sc"
  network               = var.network
  ip_address            = google_compute_global_address.psc_vip.address
}


## Health Check ##
#resource "google_compute_health_check" "backend_health_check" {
#  name    = "backend-health-check"
#  project = var.project_id
#
#  http_health_check {
#    port = 80
#  }
#}

## BE service ##

#resource "google_compute_backend_service" "backend_service" {
#  name          = "backend-service"
#  project       = var.project_id
#  health_checks = [google_compute_health_check.backend_health_check.id]
#  port_name     = "http"
#
#  backend {
#    group = google_compute_instance_group.backend_instance_group.id
#  }
#}

#resource "google_compute_instance_group" "backend_instance_group" {
#  name        = "backend-instance-group"
#  project     = var.project_id
#  zone        = "us-central1-a"
#  instances   = [var.backend_service_id]
#}

##servicve attchment ##
#resource "google_compute_service_attachment" "backend_service_attachment" {
#  name        = "backend-service-attachment"
#  project     = var.project_id
#  region      = "us-central1"
#  description = "Service Attachment for Backend Service"
#
#  # Target service (the backend service)
#  target_service = google_compute_backend_service.backend_service.id
#
#  # Enable connection to the backend service
#  connection_preference = "ACCEPT_AUTOMATIC"
#
#  # Subnets that can be used to connect to the backend service
#  nat_subnets = ["projects/psc-security-lab/regions/us-central1/subnetworks/default"]
#
#  # Enable proxy protocol if needed (optional)
#  enable_proxy_protocol = false
#}

## new psc endpoint ##
#resource "google_compute_global_address" "psc_backend_vip" {
#  name          = "psc-backend-vip"
#  project       = var.project_id
#  purpose       = "PRIVATE_SERVICE_CONNECT"
#  address_type  = "INTERNAL"
#  network       = var.network
#  address       = "10.2.2.3"
#}

#resource "google_compute_global_forwarding_rule" "psc_backend_forwarding_rule" {
#  name                  = "psc-backend-forwarding-rule"
#  project               = var.project_id
#  load_balancing_scheme = ""  # Must be empty for direct PSC
#  target                = google_compute_service_attachment.backend_service_attachment.id
#  network               = var.network
#  ip_address            = google_compute_global_address.psc_backend_vip.address
#}