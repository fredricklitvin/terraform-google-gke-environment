output "argocd_server_ip" {
  description = "Argo CD endpoint ip address."
  value       = "http://${module.helm.argocd_server_ip}:80"
}

output "argocd_initial_admin_password" {
  description = "Initial Argo CD admin password (null after first login)."
  value       = module.helm.argocd_initial_admin_password
  sensitive   = true
}