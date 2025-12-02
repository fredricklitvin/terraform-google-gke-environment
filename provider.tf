terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.44.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
     argocd = {
      source = "argoproj-labs/argocd"
      version = "7.12.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-state-fredi"
    prefix = "terraform/gkc-state"
  }
}

provider "google" {
  project = "brave-inn-477912-q1"
  region  = var.region
}


data "google_container_cluster" "container_cluster" {
  name       = "k8s"
  location   = var.region
  depends_on = [module.gke] 
}

data "google_client_config" "me" {}


provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.container_cluster.endpoint}"
  token                  = data.google_client_config.me.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.container_cluster.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.container_cluster.endpoint}"
    token                  = data.google_client_config.me.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.container_cluster.master_auth[0].cluster_ca_certificate
    )
  }
}

provider "argocd" {
  server_addr = "${module.helm.argocd_server_ip}:443"
  username    = "admin"
  password    = module.helm.argocd_initial_admin_password
  insecure = true
}