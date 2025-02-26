provider "google" {
    credentials = var.GOOGLE_CREDENTIALS
    project     = var.controllerproject
    region      = "us-central1"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.22.0"
    }
  }
}

resource "google_project_iam_member" "service_account_project_creator" {
  project = var.controllerproject
  role    = "roles/resourcemanager.projectCreator"
  member  = "terraform@testautomation-451116.iam.gserviceaccount.com"
}

# Call the network module.
module "network" {
  source          = "../../modules/network"
  project_name    = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
  network_name    = var.network_name
  subnet_name     = var.subnet_name
  subnet_cidr     = var.subnet_cidr
  region          = var.region
}

# Call the PSC endpoint module.
module "psc_endpoint" {
  source       = "../../modules/psc_endpoint"
  project_id   = module.network.lab_project_id
  network      = module.network.network_self_link
  subnetwork   = module.network.subnet_self_link
  region       = var.region
  psc_name     = var.psc_name
  psc_port     = var.psc_port
  psc_neg_name = var.psc_neg_name
  target_service = var.target_service
}

# Call the Cloud Firewall Plus module.
module "cloud_firewall_plus" {
  source               = "../../modules/cloud_firewall_plus"
  project_id           = module.network.lab_project_id
  firewall_policy_name = var.firewall_policy_name
  psc_port             = var.psc_port
  target_resource      = var.target_resource
}

# Call the Cloud Armor module.
module "cloud_armor" {
  source               = "../../modules/cloud_armor"
  project_id           = module.network.lab_project_id
  security_policy_name = var.security_policy_name
}

# Call the Traffic Director module.
module "traffic_director" {
  source                 = "../../modules/traffic_director"
  project_id             = module.network.lab_project_id
  region                 = var.region
  td_backend_name        = var.td_backend_name
  psc_neg                = module.psc_endpoint.psc_neg_self_link
  td_url_map_name        = var.td_url_map_name
  td_target_proxy_name   = var.td_target_proxy_name
  ssl_certificate        = var.ssl_certificate
}



# Deploy test workloads.
module "test_workloads" {
  source          = "../../modules/test_workloads"
  project_id      = module.network.lab_project_id
  zone            = var.zone
  network         = module.network.network_self_link
  subnetwork      = module.network.subnet_self_link
  onprem_network  = var.onprem_network
  onprem_subnetwork = var.onprem_subnetwork
  psc_endpoint_ip = module.psc_endpoint.psc_forwarding_rule_ip
}

module "cloud_ids" {
  subnetwork_name = "lab-subnet"
  source         = "../../modules/cloud_ids"
  project_id     = module.network.lab_project_id
  region         = var.region
  network        = module.network.network_self_link
  subnetwork     = module.network.subnet_self_link
  ids_name       = var.ids_name
  ids_location   = var.ids_location
  psc_endpoint_ip = module.psc_endpoint.psc_forwarding_rule_ip
}

