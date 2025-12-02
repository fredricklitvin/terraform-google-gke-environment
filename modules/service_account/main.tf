resource "google_service_account" "github_actions" {
  account_id   = "sgithub-actions-${var.project_suffix}"
  display_name = "github actions Account ${var.project_suffix}"
}

resource "google_iam_workload_identity_pool" "github_actions_pool" {
  workload_identity_pool_id = "github-actions-pool-${var.project_suffix}"
  display_name              = "GitHub Actions Pool ${var.project_suffix}"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider-${var.project_suffix}"
  display_name                     = "GitHub Actions Provider ${var.project_suffix}"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
  }

  attribute_condition = "attribute.repository == '${var.github_repository}'"
}

data "google_iam_policy" "github_iam_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions_pool.name}/attribute.repository/${var.github_repository}",
    ]
  }
  depends_on = [
    google_iam_workload_identity_pool_provider.github_provider,
  ]
}

resource "google_service_account_iam_policy" "github_iam_policy_binding" {
  service_account_id = google_service_account.github_actions.name
  policy_data        = data.google_iam_policy.github_iam_policy.policy_data
}

resource "google_project_iam_member" "artifact_registry_writer" {
  for_each = var.roles
  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}