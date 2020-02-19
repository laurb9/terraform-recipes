
resource "google_container_cluster" "test" {
  provider = google-beta
  name = "test"
  initial_node_count = 1
  location = var.zone
  ip_allocation_policy {}
  workload_identity_config {
    identity_namespace = "${data.google_client_config.current.project}.svc.id.goog"
  }
  node_config {
    machine_type = "e2-small"
    preemptible = true
    # This is what enables workload-identity
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
}
