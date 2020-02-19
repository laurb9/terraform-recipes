# Variables for concepts described in https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
# Each application can get its own service account with different GCP roles
locals {
  gsa_name = "test-app"
  ksa_name = "test-app"
  k8s_namespace = "default"
}

# GSA
resource "google_service_account" "test-app" {
  account_id = local.gsa_name
}

# KSA
resource "kubernetes_service_account" "test-app" {
  metadata {
    name = local.ksa_name
    namespace = local.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.test-app.email
    }
  }
}

# KSA-GSA binding
resource "google_service_account_iam_binding" "app-workload-id" {
  members = ["serviceAccount:${google_container_cluster.test.workload_identity_config.0.identity_namespace}[${local.k8s_namespace}/${local.ksa_name}]"]
  role = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.test-app.id
}

# Roles to be given the GSA (and made available to KSA)
# See `gcloud iam roles list`
# Example: Allow looking at objects in the bucket
resource "google_storage_bucket_iam_member" "test-bucket-read" {
  bucket = google_storage_bucket.test.name
  member = "serviceAccount:${google_service_account.test-app.email}"
  role = "roles/storage.objectViewer"
}
