data "vault_kv_secret_v2" "authentik" {
  mount = "secret"
  name  = "lab/authentik"
}

resource "kubernetes_namespace" "authentik" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "authentik" {
  name       = "authentik"
  repository = "https://charts.goauthentik.io"
  chart      = "authentik"
  version    = var.chart_version
  namespace  = kubernetes_namespace.authentik.metadata[0].name
  wait       = false

  values = [<<EOF
authentik:
  secret_key: "${data.vault_kv_secret_v2.authentik.data["secret_key"]}"
  error_reporting:
    enabled: false

postgresql:
  enabled: true
  auth:
    password: "${data.vault_kv_secret_v2.authentik.data["postgresql_password"]}"
  image:
    tag: "17"

redis:
  enabled: true
  image:
    tag: "7"
EOF
  ]

  depends_on = [kubernetes_namespace.authentik]
}
