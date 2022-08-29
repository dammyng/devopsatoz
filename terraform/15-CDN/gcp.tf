provider "google" {
  project = "my-project"
  region  = "us-central1"
}

resource "google_compute_backend_bucket" "backend_bucket" {
  name          = "backend-bucket"
  bucket_name   = "backend-bucket"
  enable_cdn    = true
  signed_url_cache_max_age_sec = 3600
  description   = "Backend bucket for my web app"
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = "https://www.googleapis.com/compute/v1/projects/my-project/global/backendBuckets/backend-bucket"

  host_rule {
    hosts = ["mydomain.com"]
  }

  path_matcher {
    name      = "path-matcher"
    default_service = "https://www.googleapis.com/compute/v1/projects/my-project/global/backendBuckets/backend-bucket"

    path_rule {
      paths = ["/"]
      service = "https://www.googleapis.com/compute/v1/projects/my-project/global/backendBuckets/backend-bucket"
    }
  }
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_url_map.url_map.self_link
  ip_address = "0.0.0.0"
  port_range = "80"
}
