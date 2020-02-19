## Proof of concept for Workload Identity on GKE

Based on:

- https://cloud.google.com/blog/products/containers-kubernetes/introducing-workload-identity-better-authentication-for-your-gke-applications
- https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity

### Deploy setup
```shell script
terraform apply
```

### Play
Follow the instructions in the terraform output to run a test container.

### Remove all resources
```shell script
terraform destroy
```
