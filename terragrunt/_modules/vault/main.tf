resource "kubernetes_namespace" "deployment" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.chart_version
  namespace  = kubernetes_namespace.deployment.metadata[0].name

  values = [<<EOF
ui:
  enabled: true

server:
  standalone:
    enabled: true
    config: |
      ui = true

      listener "tcp" {
        tls_disable = 1
        address     = "[::]:8200"
      }

      storage "file" {
        path = "/vault/data"
      }

  dataStorage:
    enabled: true
    size: ${var.storage_size}

injector:
  enabled: false
EOF
  ]

  depends_on = [kubernetes_namespace.deployment]
}
