variable project {
  description = "The GCP project being used"
  type = string
}

variable region {
  description = "The GCP region"
  type        = string
}


variable project_suffix {
  type        = string
  description = "A unique suffix for resources to prevent naming conflicts"
  default     = "v2"
}

variable github_repository {
  type        = string
  description = "The GitHub repository in 'owner/repo' format"

}

variable roles {
  type        = set(string)
  default     = [   
    "roles/artifactregistry.writer"
  ]
  description = "A set of IAM roles to assign to the service account"
}
