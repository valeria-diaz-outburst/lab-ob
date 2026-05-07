resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = var.chart_version
  namespace  = kubernetes_namespace.traefik.metadata[0].name

  values = [var.values_yaml]

  depends_on = [kubernetes_namespace.traefik]
}
