# Provider configuration
provider "google" {
  project = "my-project"
  region  = "us-central1"
}

# Resource configuration
resource "google_compute_instance" "mysql_server" {
  name         = "mysql-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20220510"
    }
  }
  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y mysql-server"

  network_interface {
    network = "default"
    access_config {
      # Include this section to give the instance a public IP address
    }
  }

  tags = ["mysql"]
}
