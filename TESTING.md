# Testing the GCP Security Lab

This document details the test cases to verify that traffic to the PSC endpoint is inspected by all security controls.

## Test Case 1: Intra-Cloud PSC Traffic Inspection
- **Objective:** Verify that traffic from an internal client VM to the PSC endpoint is inspected.
- **Steps:**
  1. SSH into the `lab-internal-client` VM.
  2. Run:  
     ```bash
     curl -s -o /dev/null -w "HTTP Code: %{http_code}\n" https://${psc_endpoint_ip}
     ```
  3. Monitor Cloud Logging for firewall (IPS) and Cloud Armor log entries.
- **Expected Outcome:** Normal HTTP traffic passes; malicious payloads trigger IPS and WAF alerts.

## Test Case 2: Hybrid/On-Prem Traffic Simulation
- **Objective:** Verify that traffic originating from simulated on‑prem (via a VPN-connected VM) is inspected.
- **Steps:**
  1. SSH into the `lab-onprem-client` VM.
  2. Run a similar `curl` command to access the PSC endpoint.
  3. Check logs for firewall rule and IDS detections.
- **Expected Outcome:** Traffic from the on‑prem VM is inspected and any disallowed protocols are blocked/logged.

## Test Case 3: Simulated Threat Traffic
- **Objective:** Trigger security policies by sending malicious traffic.
- **Steps:**
  1. From a test VM, send HTTP requests containing known attack vectors (e.g., SQL injection, XSS payloads).
  2. Observe Cloud Armor’s WAF and Cloud IDS alerts.
- **Expected Outcome:** Security controls log and block (or alert on) the malicious patterns.

## Test Case 4: Terraform Validation
- **Objective:** Ensure that the Terraform configuration is correct.
- **Steps:**
  1. Run `terraform validate` and `terraform plan` in the `env/lab/` directory.
- **Expected Outcome:** No validation errors; all resources are correctly planned for creation.

*Replace `${psc_endpoint_ip}` with the actual output from Terraform.*

---

*This test plan is designed to confirm that every layer of our defense—in-cloud and simulated on-prem—is operating as expected.*
