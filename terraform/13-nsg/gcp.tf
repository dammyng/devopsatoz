provider "google" {
  project = "my-project"
  region  = "us-central1"
}

resource "google_compute_firewall" "nsg" {
  name        = "nsg"
  network     = "default"
  description = "NSG for allowing all traffic"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["my-server-tag"]
}
