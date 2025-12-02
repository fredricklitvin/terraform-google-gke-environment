variable "gke_node_roles" {
  type        = set(string)
  default     = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader",
  ]
}

variable "secondary_ip_range_1" {
  description = "services ip range"
  type        = string
}
variable "secondary_ip_range_0" {
  description = "pods ip range"
  type        = string
}
variable "vpc_network_id" {
  description = "vpc network id"
  type        = string
}
variable "private_subnet_id" {
  description = "private subnet  id"
  type        = string
}

variable "project" {
  description = "The GCP project being used"
  type = string
}

variable "region" {
  description = "The GCP region for the GKE cluster."
  type        = string
  default     = "us-central1"
}

variable "service_account_id" {
  description = "The ID of the GKE node service account."
  type        = string
  default     = "gke-node-sa"
}

variable "service_account_display_name" {
  description = "The display name for the GKE node service account."
  type        = string
  default     = "GKE Node Service Account"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "k8s"
}

variable "node_count" {
  description = "The initial number of nodes in the GKE cluster."
  type        = number
  default     = 1
}

variable private_master_ipv4 {
  type        = string
  default     = "10.5.10.0/28"
  description = "The IP range for the private master IPv4 address."
}

variable master_authorized_cidr_block {
  type        = string
  default     = "176.231.26.0/32"
  description = "The CIDR block to authorize for master access."
}

variable initial_node_count {
  type        = string
  default     = "1"
  description = "The initial number of nodes in the cluster."
}
