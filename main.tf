provider "google" {
  access_token          = var.access_token
}

provider "google-beta"{
  access_token          = var.access_token
}

resource "google_service_account" "dataproc-sa" {
  account_id   = "dataproc-sa-id"
  display_name = "Service Account"
  project = "airline1-sabre-wolverine"
}

resource "google_project_iam_member" "dataproc-worker" {
  project = "airline1-sabre-wolverine"
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc-sa.email}"
}

resource "google_dataproc_cluster" "cluster-wsar" {
  name     = "cluster-wsar"
  provider = google-beta
  project = "airline1-sabre-wolverine"
  region   = "us-central1"

  graceful_decommission_timeout = "120s"

  labels = {
    gcp_region = "us-central1"
    owner = "wf"
    application_division = "pci"
    application_name = ""
    application_role = "auth"
    environment = "dev"
    au = ""
    created = "20211001"
  }

  cluster_config {
    staging_bucket = "dataproc-staging-bucket123"
    
    gce_cluster_config {
      tags = ["foo", "bar"]
      internal_ip_only = true
      
      #network    = "projects/airline1-sabre-wolverine/global/networks/savita-vpc"
      subnetwork = "projects/airline1-sabre-wolverine/regions/us-central1/subnetworks/savita-subnet-vpc1"

      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      service_account = google_service_account.dataproc-sa.email
      service_account_scopes = [
        "cloud-platform"
      ]
    }

    master_config {
      num_instances = 1
      machine_type  = "e2-medium"
    }

    worker_config {
      num_instances    = 2
      machine_type     = "e2-medium"
      #min_cpu_platform = "Intel Skylake"
    }

    preemptible_worker_config {
      num_instances = 0
    }

    # Override or set some custom properties
    software_config {
      image_version = "1.3.7-deb9"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }


    encryption_config{
        kms_key_name = ""
    }

    endpoint_config{
        enable_http_port_access = false
    }
  }
   depends_on = [google_service_account.dataproc-sa,google_project_iam_member.dataproc-worker]
}

resource "google_dataproc_cluster" "cluster-wsae" {
  name     = "cluster-wsae"
  provider = google-beta
  project = "airline1-sabre-wolverine"
  region   = "us-east1"

  graceful_decommission_timeout = "120s"

  labels = {
    gcp_region = "us-central1"
    owner = "wf"
    application_division = "pci"
    application_name = ""
    application_role = "auth"
    environment = "dev"
    au = ""
    created = "20211001"
  }

  cluster_config {
    staging_bucket = "dataproc-staging-bucket123"
    
    gce_cluster_config {
      tags = ["foo", "bar"]
      internal_ip_only = true
      
      #network    = "projects/airline1-sabre-wolverine/global/networks/savita-vpc"
      subnetwork = "projects/airline1-sabre-wolverine/regions/us-east1/subnetworks/savita-subnet-vpc-2"

      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      service_account = "demo-sentinel-sa@airline1-sabre-wolverine.iam.gserviceaccount.com"
      service_account_scopes = [
        "cloud-platform"
      ]
    }

    master_config {
      num_instances = 1
      machine_type  = "e2-medium"
    }

    worker_config {
      num_instances    = 2
      machine_type     = "e2-medium"
      #min_cpu_platform = "Intel Skylake"
    }

    preemptible_worker_config {
      num_instances = 0
    }

    # Override or set some custom properties
    software_config {
      image_version = "1.3.7-deb9"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }

    encryption_config{
        kms_key_name = ""
    }

    endpoint_config{
        enable_http_port_access = false
    }
  }
}


