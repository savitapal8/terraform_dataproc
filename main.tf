provider "google" {
  access_token          = var.access_token
}

provider "google-beta"{
  access_token          = var.access_token
}

resource "google_service_account" "cloud-composer-sa" {
  account_id   = "cloud-composer-sa-id"
  display_name = "Service Account"
  project = var.project
}
