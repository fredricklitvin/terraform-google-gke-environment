# locals {
#   argocd_rendered_values = templatefile("${path.module}/argocd-values.yaml"
#   # ,{git_repo_url = var.github_repository , k8s_path = var.k8s_path}
#   )
# }


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  timeout = 300

  

#  values = [
#     file("${path.module}/argocd-values.yaml")
#   ]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  # set {
  #   name  = "configs.secret.createSecret"
  #   value = "true"
  # }

  # set {
  #   name  = "configs.secret.argocdServerAdminPassword"
  #   value = "plaintext:${var.admin_password}"
  # }
}
