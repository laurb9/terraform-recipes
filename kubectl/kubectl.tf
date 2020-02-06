locals {
  cluster      = google_container_cluster.test
  cluster_name = google_container_cluster.test.name
}

# Simple test cluster with one node
resource "google_container_cluster" "test" {
  name = "test"
  initial_node_count = 1
  node_config {
    machine_type = "e2-small"
    preemptible = true
  }
}

# kubectl config file for above cluster
# Embeds credentials in the terraform state so should not be used when state is shared or not private
resource "local_file" "kubectl_config" {
  filename        = ".kubeconfig"
  file_permission = "0644"
  content         = <<EOF
apiVersion: v1
kind: Config
current-context: ${local.cluster_name}
clusters:
- cluster:
    server: https://${google_container_cluster.test.endpoint}
    certificate-authority-data: ${google_container_cluster.test.master_auth[0].cluster_ca_certificate}
  name: ${local.cluster_name}
contexts:
- context:
    cluster: ${local.cluster_name}
    user: ${local.cluster_name}
  name: ${local.cluster_name}
users:
- name: ${local.cluster_name}
  user:
    token: ${data.google_client_config.current.access_token}
EOF
}

resource "null_resource" "version" {
  depends_on = [local_file.kubectl_config]
  triggers = {
    a = local_file.kubectl_config.content
  }
  provisioner "local-exec" {
    command = <<EOF
kubectl config get-contexts
kubectl version
kubectl run --rm -it --image=ubuntu --restart=Never shell -- bash -c "ps axuf"
EOF
    environment = {
      KUBECONFIG = local_file.kubectl_config.filename
    }
  }
}
