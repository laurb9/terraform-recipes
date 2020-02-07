## Proof of concept for Serverless VPC Access

VPC Connector allows a Cloud Function to access other resources with internal IPs
such as Kubernetes LoadBalancer services with internal IP, CloudSQL instances etc.

https://cloud.google.com/functions/docs/networking/connecting-vpc

In this project, a bare-bones nginx server runs on a tiny Kubernetes cluster, 
exposed on an internal IP, to simulate a backend service. 

Then a simple cloud function will be able to reach this internal IP through
the VPC connector.

`CF` → `VPC Connector` → `VPC` → `ILB` → `K8S Service` → `nginx`

For this setup, the terraform SA needs "Project Owner" role.

### Deploy
```shell script
terraform apply
```

### Play
`terraform apply` should have printed the URL of the cloud function.
Open the url in the browser or `curl` to see the response headers
from the nginx server and the environment variables visible to the CF.

### Remove all resources
```shell script
terraform destroy
```
