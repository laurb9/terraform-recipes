output "test_commands" {
  value = <<EOF

# Start test pod:

gcloud container clusters get-credentials test

kubectl run --rm -it --generator=run-pod/v1 --image google/cloud-sdk:slim workload-identity-test \
  --serviceaccount ${local.ksa_name} --namespace ${local.k8s_namespace}

# commands to try inside the pod
  cloud auth list

# These would fail without the google_storage_bucket_iam_member resource
  gsutil ls -l ${google_storage_bucket.test.url}
  gsutil cat ${google_storage_bucket.test.url}/${google_storage_bucket_object.index.output_name}
EOF
}
