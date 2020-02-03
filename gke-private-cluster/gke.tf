data "google_container_engine_versions" "k8s_versions" {
  project        = var.project
  location       = var.zone
  version_prefix = "1.14.8-"
}

resource "google_container_cluster" "apps" {
  provider           = google-beta
  name               = "apps"
  min_master_version = data.google_container_engine_versions.k8s_versions.latest_master_version
  node_version       = data.google_container_engine_versions.k8s_versions.latest_node_version
  # Set location = var.region for a regional cluster
  location                  = var.zone
  network                   = google_compute_network.main.self_link
  subnetwork                = google_compute_subnetwork.subnet.self_link
  default_max_pods_per_node = 32
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name # "pods"
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name # "services"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = cidrsubnet("172.16.0.0/24", 4, 1) # 172.16.0.16/28
  }
  workload_identity_config {
    identity_namespace = "${data.google_client_config.current.project}.svc.id.goog"
  }
  addons_config {
    network_policy_config {
      disabled = true
    }
    istio_config {
      disabled = true
      auth     = "AUTH_NONE"
    }
  }
  release_channel {
    channel = "REGULAR"
  }
  initial_node_count       = 1
  remove_default_node_pool = true
  node_config {
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
}

resource google_container_node_pool "apps" {
  provider           = google-beta
  name               = "apps"
  cluster            = google_container_cluster.apps.name
  initial_node_count = 1
  autoscaling {
    max_node_count = 3
    min_node_count = 1
  }
  max_pods_per_node = 64
  node_config {
    machine_type = var.apps_machine_type
    preemptible  = false
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
}
