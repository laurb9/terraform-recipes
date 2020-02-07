# Bare-bones nginx in a cluster to simulate a backend service for the CF

# A one-node cluster
resource "google_container_cluster" "test" {
  name = "test"
  initial_node_count = 1
  location = var.zone
  ip_allocation_policy {}
  node_config {
    machine_type = "e2-small"
    preemptible = true
  }
}

# Static internal IP so we know what the CF will connect to
resource "google_compute_address" "nginx" {
  name = "nginx"
  region = google_container_cluster.test.region
  subnetwork = "default"
  address_type = "INTERNAL"
}

# nginx deployment+service exposed on an Internal LoadBalancer using above IP.
# Real applications shouldn't be deployed with terraform like this.
resource "kubernetes_service" "nginx" {
  depends_on = [google_container_cluster.test]
  provider = kubernetes
  metadata {
    name = "nginx"
    annotations = {
      "cloud.google.com/load-balancer-type": "Internal"     # deprecated
      "networking.gke.io/load-balancer-type" : "Internal"   # new
    }
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
    type             = "LoadBalancer"
    session_affinity = "ClientIP"
    load_balancer_ip = google_compute_address.nginx.address
  }
}

resource "kubernetes_deployment" "nginx" {
  depends_on = [google_container_cluster.test]
  metadata {
    name = "nginx"
  }
  spec {
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
