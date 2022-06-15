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

resource "google_project_iam_member" "dataproc-worker" {
  project = var.project
  role    = "roles/composer.ServiceAgentV2Ext"
  member  = "serviceAccount:${google_service_account.dataproc-sa.email}"
}
