provider "google" {
  project = "my-project-id"
  region  = "us-central1"
}

resource "google_storage_bucket" "example" {
  name = "example-bucket"
}
