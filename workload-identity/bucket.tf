# This bucket is just to test
resource "google_storage_bucket" "test" {
  name = "${var.project}-test"
  location = var.region
  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_object" "index" {
  bucket = google_storage_bucket.test.name
  name = "index.html"
  content_type = "text/html"
  content = <<EOF
<html>
</html>
EOF
}
