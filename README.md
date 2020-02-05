# terraform-recipes
Simple terraform recipes for standing up and testing GCP functionality

## Basic requirements

### terraform

Install from https://www.terraform.io/downloads.html
Homebrew(Mac): `brew install terraform`

### Terraform service account

This is optional but best practice, see https://www.terraform.io/docs/providers/google/guides/provider_reference.html#credentials

Go to https://console.cloud.google.com/iam-admin/serviceaccounts/create
1. Create a new service account called "terraform" 
(actual name does not matter but it helps to indicate what it is for).
2. Grant "Project Editor" access to this service account.
3. Select the new service account and create a `json` key; save it locally.
This will be the path to enter for `terraform-gcp-sa-file` in variables.tf
```hcl
variable "terraform-gcp-sa-file" {
  default = "/path/to/account.json"
}
```

## Optional

### GCloud sdk

Install from https://cloud.google.com/sdk/docs/downloads-versioned-archives
Homebrew(Mac): `brew cask install google-cloud-sdk`

### kubectl

Install from https://kubernetes.io/docs/tasks/tools/install-kubectl/
Homebrew(Mac): `brew install kubectl`

### helm

Install from https://github.com/helm/helm
Homebrew(Mac): `brew install helm`
