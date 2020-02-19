# https://www.terraform.io/docs/providers/google/provider_reference.html
provider "google" {
  credentials = file(var.terraform-gcp-sa-file)
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.terraform-gcp-sa-file)
  project     = var.project
  region      = var.region
}

provider "kubernetes" {
  host                   = google_container_cluster.test.endpoint
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.test.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "current" {}
