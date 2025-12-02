variable github_repository {
  type        = string
  description = "The GitHub repository URL for ArgoCD to sync from"
}

variable k8s_path {
  type        = string
  description = "The path within the GitHub repository where the Kubernetes manifests are located"
}
variable admin_password {
  type        = string
  description = "The initial admin password for ArgoCD"
  default     = "12qw12!!"
}
