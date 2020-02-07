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
