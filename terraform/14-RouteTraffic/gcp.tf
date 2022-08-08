# Define provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create instance template
resource "google_compute_instance_template" "web_template" {
  name_prefix = "web-template-"
  machine_type = "n1-standard-1"

  disk {
    source_image = "debian-cloud/debian-10"
  }

  network_interface {
    network = "default"
    access_config {
      // Create a new ephemeral IP for each instance
    }
  }

  metadata = {
    // Install Apache web server
    "startup-script" = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
    EOF
  }

  tags = ["web"]
}

# Create managed instance group
resource "google_compute_instance_group_manager" "web_group" {
  name = "web-group"
  base_instance_name = "web-instance"
  instance_template = google_compute_instance_template.web_template.self_link
  target_size = 3

  # Autoscaling policy
  auto_scaling_policy {
    max_replicas = 5
    min_replicas = 2
    cool_down_period_sec = 90
    cpu_utilization {
      target_utilization = 0.6
    }
  }

  # Health check for load balancer
  named_port {
    name = "http"
    port = 80
  }

  target_pools = [google_compute_target_pool.web_pool.self_link]
}

# Create target pool
resource "google_compute_target_pool" "web_pool" {
  name = "web-pool"
  region = var.region

  health_checks = [google_compute_http_health_check.web_health_check.self_link]
}

# Create health check
resource "google_compute_http_health_check" "web_health_check" {
  name = "web-health-check"
  check_interval_sec = 10
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 3
  port = 80
  request_path = "/"
}

# Create forwarding rule for load balancer
resource "google_compute_forwarding_rule" "web_forwarding_rule" {
  name = "web-forwarding-rule"
  region = var.region

  port_range = "80"
  target = google_compute_target_pool.web_pool.self_link
}
