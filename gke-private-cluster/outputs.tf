output "master_ipv4_cidr" {
  value = google_container_cluster.apps.private_cluster_config[0].master_ipv4_cidr_block
}

output "network_ipv4_range" {
  value = google_compute_network.main.ipv4_range
}

output "subnet_ip_cidr_range" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}

output "cluster_ipv4_cidr" {
  value = google_container_cluster.apps.cluster_ipv4_cidr
}

output "services_ipv4_cidr" {
  value = google_container_cluster.apps.services_ipv4_cidr
}
