terraform {
  backend "s3" {
    bucket = "bb1-tfstates"
    
    # override the key using -backend-config during init, e.g. terraform init -backend-config="key=tfstates/my_cloud_name"
    # terraform does not support variable here, see https://github.com/hashicorp/terraform/issues/13022
    # and https://github.com/hashicorp/terraform/issues/17288
    key    = "tfstates/default_key"
    region = "eu-central-1"
  }
}
