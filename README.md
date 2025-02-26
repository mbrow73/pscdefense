# GCP Security Lab: PSC Endpoint Inspection

This repository sets up a GCP lab environment to demonstrate inspection of traffic destined to a Private Service Connect (PSC) endpoint using multiple Google Cloud-native security controls:

- **Cloud Firewall Plus (NGFW)** with IPS and TLS Inspection (Google’s NGFW capabilities)
- **Cloud Armor** for web application security filtering
- **Traffic Director** with an Envoy proxy for inline L7 control
- **Cloud IDS** for network threat detection

## Overview

The lab creates a new GCP project, configures a Shared VPC with a PSC endpoint connecting to a Google‑managed service, deploys a suite of security controls, and sets up test workloads to generate traffic. This environment demonstrates that traffic to the PSC endpoint can be inspected both from within Google Cloud and from on‑prem (simulated via a VPN).

## Repository Structure
. ├── README.md ├── TESTING.md ├── diagrams/ │ └── architecture.png ├── modules/ │ ├── network/ │ ├── psc_endpoint/ │ ├── cloud_firewall_plus/ │ ├── cloud_armor/ │ ├── traffic_director/ │ ├── cloud_ids/ │ └── test_workloads/ ├── env/ │ └── lab/ │ ├── main.tf │ ├── variables.tf │ └── outputs.tf └── terraform.tfvars

## Deployment Instructions

1. **Configure Variables:**  
   Edit `terraform.tfvars` with your GCP credentials, project name, project ID, org ID, and billing account details.

2. **Terraform Cloud Integration:**  
   This repository is hooked up to a Terraform Cloud workspace. Ensure your workspace is configured with the remote backend and required variables.

3. **Deploy the Lab:**
   - Navigate to the `env/lab/` folder.
   - Run `terraform init` to initialize the workspace.
   - Run `terraform plan` to review the resources.
   - Run `terraform apply` to provision the lab environment.

4. **Testing:**  
   Follow [TESTING.md](TESTING.md) for test case instructions to validate that both intra‑cloud and simulated on‑prem traffic are inspected by the security controls.

## References & Citations
- Google Cloud Firewall Plus: 
- Cloud Armor Best Practices: 
- Traffic Director with Envoy: 
- Cloud IDS Documentation: 
- Private Service Connect: 

*This lab is provided as a reference implementation and can be customized as needed.*

---

*Happy Testing!*


