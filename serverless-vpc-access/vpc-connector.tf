# Deploy a VPC connector for Cloud Function in its region
# https://cloud.google.com/functions/docs/connecting-vpc

data "google_project" "project" {}

locals {
  cf_service_agent = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
}

# These service enablements seem to be required
# Best practice is disable_on_destroy=false to avoid disabling pre-enabled APIs on destroy
resource "google_project_service" "cloudbilling" {
  service = "cloudbilling.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "vpcaccess" {
  service = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_iam_binding" "cf-project-viewer" {
  members = [local.cf_service_agent]
  role = "roles/viewer"
}

resource "google_project_iam_binding" "cf-network-user" {
  members = [local.cf_service_agent]
  role = "roles/compute.networkUser"
}

resource "google_vpc_access_connector" "vpc-connector" {
  depends_on = [google_project_service.vpcaccess]
  provider = google-beta
  name = "vpc-connector"
  region = var.region
  ip_cidr_range = "192.168.0.0/28"
  network = "default"
}
