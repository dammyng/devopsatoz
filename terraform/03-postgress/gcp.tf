provider "google" {
  project = "my-project"
  region  = "us-central1"
}

resource "google_compute_instance" "postgres" {
  name         = "postgres"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash
                            apt-get update
                            apt-get -y install postgresql
                            systemctl start postgresql
                            systemctl enable postgresql
                            EOF

  network_interface {
    network = "default"
  }
}

resource "google_compute_firewall" "postgres" {
  name    = "postgres"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
}
