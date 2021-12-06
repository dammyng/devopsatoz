provider "google" {
  project = "example-project"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "example" {
  name         = "example-instance"
  machine_type = "f1-micro"
  tags         = ["http-server"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    service apache2 start
    echo "<h1>Welcome to the Example Web App!</h1>" > /var/www/html/index.html
  SCRIPT

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "http" {
  name    = "http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
