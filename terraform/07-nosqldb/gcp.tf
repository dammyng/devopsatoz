provider "google" {
  project = "my-project"
  region  = "us-central1"
}

resource "google_firestore_database" "example" {
  name = "example_db"
  location = "us-central1"
}

resource "google_firestore_index" "example_index" {
  collection_group = "example_collection"
  fields {
    field_path = "field1"
    order = "ASCENDING"
  }
}
