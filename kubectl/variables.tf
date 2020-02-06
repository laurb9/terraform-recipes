variable "terraform-gcp-sa-file" {
  description = "Path to Terraform Service Account json file"
}

variable "project" {
  description = "Project id to deploy infrastructure under"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "apps_machine_type" {
  default     = "e2-small"
  description = "Machine type for the apps cluster"
}
