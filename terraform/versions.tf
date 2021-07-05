terraform {
  required_version = ">= 0.12"
}

provider "random" {
  version = "2.3.1"
}

provider "local" {
  version = "1.4.0"
}

provider "null" {
  version = "2.1.2"
}

provider "template" {
  version = "2.2.0"
}
