# Configure the GCP provider
provider "google" {
  project = "my-project"
  region  = "us-central1"
}

# Create a GCE instance
resource "google_compute_instance" "example" {
  name         = "example-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }
}
