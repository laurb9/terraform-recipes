# https://www.terraform.io/docs/providers/google/provider_reference.html
provider "google" {
  credentials = file(var.terraform-gcp-sa-file)
  region      = var.region
  zone        = var.zone
  project     = var.project
}

provider "google-beta" {
  credentials = file(var.terraform-gcp-sa-file)
  region      = var.region
  zone        = var.zone
  project     = var.project
}

provider "kubernetes" {
  alias                  = "apps"
  host                   = google_container_cluster.apps.endpoint
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.apps.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}

data "google_client_config" "current" {}
