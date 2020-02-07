
output "cf_url" {
  value = "${google_cloudfunctions_function.test.https_trigger_url}?message=call_nginx"
}

output "cf_sa" {
  value = google_cloudfunctions_function.test.service_account_email
}
