provider "google" {
  project = "my-project"
  region  = "us-central1"
}

resource "google_pubsub_topic" "topic" {
  name = "my-topic"
}

resource "google_pubsub_subscription" "subscription" {
  name  = "my-subscription"
  topic = google_pubsub_topic.topic.name
}
