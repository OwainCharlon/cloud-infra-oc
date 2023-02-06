##v1
provider "google" {
  #version = "3.5.0"
  credentials = file("C:/data/Cloud/terra-tp-c010315a0519.json")
  project = "terra-tp"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "lab-infra-cloud-owain"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "lab-infra-cloud-owain-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.name
}

##V2
resource "google_service_account" "default" {
  account_id   = "terra-tp-c010315a0519"
  display_name = "oc-terra"
}

resource "google_container_cluster" "primary" {
  name     = "lab-infra-cloud-owain-cluster"
  location = "europe-west1"
  network = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.public-subnetwork.name
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "lab-infra-cloud-owain-nodepool"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 2
  
  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
    disk_size_gb = 20

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}