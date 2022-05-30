provider "google" {
  project = "my-project-id"
  region  = "us-central1"
}

resource "google_compute_backend_service" "backend-service" {
  name = "my-backend-service"

  backend {
    group = "my-instance-group"
  }
}

resource "google_compute_health_check" "health-check" {
  name               = "my-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  tcp_health_check {
    port = 80
  }
}

resource "google_compute_url_map" "url-map" {
  name            = "my-url-map"
  default_service = "${google_compute_backend_service.backend-service.self_link}"

  host_rule {
    hosts = ["mydomain.com"]
    path_matcher = "my-path-matcher"
  }

  path_matcher {
    name            = "my-path-matcher"
    default_service = "${google_compute_backend_service.backend-service.self_link}"

    path_rule {
      paths        = ["/path1/*"]
      service      = "${google_compute_backend_service.backend-service.self_link}"
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/app1/"
        }
      }
    }

    path_rule {
      paths        = ["/path2/*"]
      service      = "${google_compute_backend_service.backend-service.self_link}"
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/app2/"
        }
      }
    }
  }
}

resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name       = "my-forwarding-rule"
  ip_address = "0.0.0.0"
  port_range = "80-80"

  target = "${google_compute_url_map.url-map.self_link}"
}

