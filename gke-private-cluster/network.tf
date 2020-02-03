resource "google_compute_network" "main" {
  name                    = "main"
  project                 = data.google_client_config.current.project
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# Create a subnet for the cluster
resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet"
  project                  = data.google_client_config.current.project
  region                   = var.region
  network                  = google_compute_network.main.self_link
  private_ip_google_access = true
  ip_cidr_range            = cidrsubnet("10.10.0.0/18", 4, 1) # 10.10.4.0/22
  secondary_ip_range {
    ip_cidr_range = cidrsubnet("10.0.0.0/16", 4, 1) # 10.0.16.0/20
    range_name    = "pods"
  }
  secondary_ip_range {
    ip_cidr_range = cidrsubnet("10.1.0.0/17", 4, 1) # 10.1.8.0/21
    range_name    = "services"
  }
}

resource "google_compute_router" "router" {
  name    = "router"
  project = data.google_client_config.current.project
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.main.self_link
}


resource "google_compute_router_nat" "router_nat" {
  depends_on             = [google_compute_subnetwork.subnet]
  name                   = "router-nat"
  nat_ip_allocate_option = "AUTO_ONLY"
  router                 = google_compute_router.router.name
  region                 = google_compute_router.router.region
  # this would cover the nodes, pods and services
  #source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  # Nodes
  subnetwork {
    name                    = google_compute_subnetwork.subnet.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }
  # Pods
  subnetwork {
    name                     = google_compute_subnetwork.subnet.self_link
    source_ip_ranges_to_nat  = ["LIST_OF_SECONDARY_IP_RANGES"]
    secondary_ip_range_names = [google_container_cluster.apps.ip_allocation_policy.0.cluster_secondary_range_name]
  }
}
