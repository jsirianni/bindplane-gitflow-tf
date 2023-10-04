// Store state in GCS
terraform {
  backend "gcs" {
    bucket = "bindplane-gitflow-tf"
    prefix = "terraform"
  }
}
