provider "google" {
  region = "us-central1"
}

resource "google_compute_network" "example" {
  name                    = "example-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "example" {
  name          = "example-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.example.self_link
}

resource "google_compute_global_address" "example" {
  name = "example-address"
}

resource "google_compute_address" "example" {
  name         = "example-address"
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.example.self_link
  address      = google_compute_global_address.example.address
}

resource "google_compute_router" "example" {
  name = "example-router"
}

resource "google_compute_router_interface" "example" {
  router             = google_compute_router.example.name
  region             = google_compute_network.example.region
  ip_range           = "10.0.1.0/24"
  linked_vpn_tunnel  = null
  linked_interconnect = null
  subnetwork         = google_compute_subnetwork.example.self_link
}

resource "google_compute_route" "example" {
  name                  = "example-route"
  network               = google_compute_network.example.self_link
  priority              = 1000
  destination_range     = "0.0.0.0/0"
  next_hop_network      = null
  next_hop_gateway      = google_compute_router_interface.example.ip_address
  next_hop_instance     = null
  next_hop_vpn_tunnel   = null
  next_hop_gateway_vpc  = null
  next_hop_ilb          = null
}

resource "google_compute_firewall" "example" {
  name    = "example-firewall"
  network = google_compute_network.example.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
