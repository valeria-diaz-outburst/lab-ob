resource "kubernetes_namespace" "deployment" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "authentik" {
  name       = "authentik"
  repository = "https://charts.goauthentik.io"
  chart      = "authentik"
  version    = var.chart_version
  namespace  = kubernetes_namespace.deployment.metadata[0].name

  values = [<<EOF
authentik:
  secret_key: "${var.authentik_secret_key}"
  error_reporting:
    enabled: false

postgresql:
  enabled: true
  auth:
    password: "${var.postgresql_password}"

redis:
  enabled: true
EOF
  ]

  depends_on = [kubernetes_namespace.deployment]
}
