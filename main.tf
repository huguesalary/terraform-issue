locals {
  namespace = "default"
}

resource "kubernetes_manifest" "cert_manager_crds" {
  for_each = fileset(path.module, "kubernetes-manifests/cert-manager/**/*.yaml.tpl")

  manifest = yamldecode(
    templatefile(
      "${path.module}/${each.value}",
      { namespace = local.namespace }
    )
  )
}

provider "kubernetes" {
  host                   = ""
  cluster_ca_certificate = base64decode("")
  token                  = ""
}

terraform {
  required_providers {
    kubernetes = {
      # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
      source  = "hashicorp/kubernetes"
      version = ">= 2.8.0"
    }
  }

  required_version = ">= 0.13"
}
