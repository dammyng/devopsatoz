provider "google" {
  region = "us-west1"
}

resource "google_compute_address" "ip" {
  name = "example-ip"
}
