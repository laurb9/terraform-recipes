# Deploy Cloud Function from cloudfunction/test

resource "google_cloudfunctions_function" "test" {
  provider = google-beta
  region = var.region
  name = "test-vpc-connector"
  vpc_connector = google_vpc_access_connector.vpc-connector.name
  runtime = "python37"
  source_archive_bucket = google_storage_bucket.cf_bucket.name
  source_archive_object = google_storage_bucket_object.cf_source.output_name
  available_memory_mb = 128
  trigger_http = true
  entry_point = "main"
  environment_variables = {
    HTTP_ENDPOINT = google_compute_address.nginx.address
  }
}

resource "google_storage_bucket" "cf_bucket" {
  name = data.google_client_config.current.project
}

resource "google_storage_bucket_object" "cf_source" {
  bucket = google_storage_bucket.cf_bucket.name
  name = "cf-${data.archive_file.cf_zip.output_sha}"
  source = data.archive_file.cf_zip.output_path
}

data "archive_file" "cf_zip" {
  type        = "zip"
  output_path = "./cloudfunction/cf.zip"
  source_dir  = "./cloudfunction/test"
}

resource "google_cloudfunctions_function_iam_member" "test" {
  project = data.google_client_config.current.project
  region = var.region
  cloud_function = google_cloudfunctions_function.test.name
  member = "allUsers"
  role = "roles/cloudfunctions.invoker"
}
