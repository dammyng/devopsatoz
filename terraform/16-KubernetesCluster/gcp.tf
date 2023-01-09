# Configure the Google Cloud provider
provider "google" {
  project = "<PROJECT_ID>"
  region  = "us-central1"
}

# Set the default machine type for the worker nodes
variable "machine_type" {
  default = "n1-standard-2"
}

# Create a Google Kubernetes Engine cluster
resource "google_container_cluster" "primary" {
  name               = "example-cluster"
  location           = "us-central1"
  initial_node_count = 1

  node_config {
    machine_type = var.machine_type
  }
}

# Connect to the cluster
data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}
