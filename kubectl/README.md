## Proof of concept for running kubectl commands

### Warnings

1. This method is easier to read than others but embeds the GCP SA key in the state 
and prints it to stdout, so should not be used when state or logs can be accessed by others.

2. Not the way to create kubernetes resources. It is only a last resort
when kubernetes provider lacks the functionality.

### Deploy
```shell script
terraform apply
```

### Remove all resources
```shell script
terraform destroy
```
