data "vault_kv_secret_v2" "authentik" {
  mount = "secret"
  name  = "lab/authentik"
}

resource "kubernetes_namespace" "authentik" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "postgres" {
  metadata {
    name      = "authentik-postgres"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }
  data = {
    password = data.vault_kv_secret_v2.authentik.data["postgresql_password"]
  }
}

resource "kubernetes_stateful_set_v1" "postgres" {
  metadata {
    name      = "authentik-postgres"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }

  spec {
    service_name = "authentik-postgres"
    replicas     = 1

    selector {
      match_labels = {
        app = "authentik-postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "authentik-postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:17-alpine"

          env {
            name  = "POSTGRES_DB"
            value = "authentik"
          }
          env {
            name  = "POSTGRES_USER"
            value = "authentik"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "local-path"
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "postgres" {
  metadata {
    name      = "authentik-postgres"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }

  spec {
    selector = {
      app = "authentik-postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment_v1" "redis" {
  metadata {
    name      = "authentik-redis"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "authentik-redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "authentik-redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7-alpine"

          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "redis" {
  metadata {
    name      = "authentik-redis"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }

  spec {
    selector = {
      app = "authentik-redis"
    }
    port {
      port        = 6379
      target_port = 6379
    }
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
    host: "authentik-postgres"
    name: "authentik"
    user: "authentik"
    password: "${data.vault_kv_secret_v2.authentik.data["postgresql_password"]}"
  redis:
    host: "authentik-redis"

server:
  ingress:
    enabled: true
    ingressClassName: traefik
    hosts:
      - host: authentik.lab
        paths:
          - path: /
            pathType: Prefix

postgresql:
  enabled: false

redis:
  enabled: false
EOF
  ]

  depends_on = [
    kubernetes_service_v1.postgres,
    kubernetes_service_v1.redis,
  ]
}
