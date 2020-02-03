GKE Private Cluster with Workload-Identity enabled

Set up a zonal cluster with private node IPs behind a NAT router.

This is a more secure configuration than the default public one.
The NAT router enables nodes to pull images from external docker repositories and 
allows workloads to access the internet, while protecting both from direct access 
from the internet.

To make the setup easier to read, only repeated values have been extracted in variables.tf

```bash
terraform apply

gcloud config set compute/region us-central1
gcloud config set compute/zone   us-central1-a

gcloud container clusters get-credentials apps
# Now can use kubectl, helm etc. in this cluster
kubectl version
kubectl get all

# Inspect some of the deployed objects
gcloud container clusters describe apps
gcloud container networks subnets describe subnet
gcloud compute routers describe router

# Delete everything
terraform destroy
```
