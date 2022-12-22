terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.8.0"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {

}

locals {
  project_name = "default"
}
data "scaleway_account_project" "current" {
  name = local.project_name
}