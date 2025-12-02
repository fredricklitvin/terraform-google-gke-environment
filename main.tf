module "service" {
  source = "./modules/services"
  project = "brave-inn-477912-q1"
  
  }
module network {
  source = "./modules/network"
}

module firewall {
  source = "./modules/firewall"
  vpc_network_id = module.network.vpc_network_id
}

module vm {
  source = "./modules/vm"
  subnet_id = module.network.private_subnet_id
  zone = "us-central1-a"
}

module "gke" {
  source = "./modules/gke"
  project = "brave-inn-477912-q1"
  vpc_network_id = module.network.vpc_network_id
  private_subnet_id = module.network.private_subnet_id
  secondary_ip_range_1 = module.network.private_subnet_ip_range_1
  secondary_ip_range_0 = module.network.private_subnet_ip_range_0
  region = var.region
}

module "helm" {
  source = "./modules/helm"
  depends_on = [module.gke]
  github_repository = "https://github.com/fredricklitvin/k8s-project-helm.git"
  k8s_path = "k8s-app"

}
module "artifact" {
  source = "./modules/artifact"
  region = var.region

}

module "service_account" {
  source = "./modules/service_account"
  project = "brave-inn-477912-q1"
  region = var.region
  github_repository = "https://github.com/fredricklitvin/k8s-project-helm.git"
  project_suffix = "v6"

}

module "argocd" {
  source = "./modules/argocd"
  depends_on = [module.helm]
}
