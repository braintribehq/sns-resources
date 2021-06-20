terraform {
  backend "s3" {
    bucket = "customer-terraformstates"
    key    = "terraformstates/default_key"
    region = "eu-central-1"
  }
}
