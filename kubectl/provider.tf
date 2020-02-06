# https://www.terraform.io/docs/providers/google/provider_reference.html
provider "google" {
  credentials = file(var.terraform-gcp-sa-file)
  region      = var.region
  zone        = var.zone
  project     = var.project
}

data "google_client_config" "current" {}
