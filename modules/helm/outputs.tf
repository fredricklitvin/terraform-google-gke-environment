data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server" 
    namespace = helm_release.argocd.namespace
  }
    depends_on             = [helm_release.argocd]
}

output "argocd_server_ip" {
  description = "The external IP for the Argo CD server LoadBalancer."
  value = try(
    coalesce(
      data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip
    ),
    "LoadBalancer IP is pending. Run 'kubectl get svc -n argocd' after apply."
  )
}


data "kubernetes_secret_v1" "argocd_initial_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = helm_release.argocd.namespace
  }
  depends_on = [helm_release.argocd]
}

output "argocd_initial_admin_password" {
  value     = try(data.kubernetes_secret_v1.argocd_initial_admin.data["password"], null)
  sensitive = true
  description = "Initial Argo CD admin password (null after first login)"
}
