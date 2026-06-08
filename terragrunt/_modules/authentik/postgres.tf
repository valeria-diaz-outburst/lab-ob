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
    name = "authentik-postgres"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }
}

specs {
  service_name = "authentik-ppostgres"
  replicas =1

  selector {
    match_labels = {app = "authentik-ppostgres"}
  }


  template {
    metadata {
      labels = { app = "authentik-postgres" }
    }
    spec {
      container {
        name  = "postgres"
        image = "postgres:17-alpine"

        env { name = "POSTGRES_DB",   value = "authentik" }
        env { name = "POSTGRES_USER", value = "authentik" }
        env {
          name = "POSTGRES_PASSWORD"
          value_from {
            secret_key_ref {
              name = kubernetes_secret_v1.postgres.metadata[0].name
              key  = "password"
            }
          }
        }
        env { name = "PGDATA", value = "/var/lib/postgresql/data/pgdata" }

        port { container_port = 5432 }

        volume_mount {
          name       = "data"
          mount_path = "/var/lib/postgresql/data"
        }
      }
    }
  }

  volume_claim_template {
    metadata { name = "data" }
    spec {
      access_modes       = ["ReadWriteOnce"]
      storage_class_name = "local-path"
      resources { requests = { storage = "1Gi" } }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "authentik-postgres"
    namespace = "authentik"
  }
  spec {
    selector = { app = "authentik-postgres"}
    port { port = 5432, target_port = 5432}
  }
}



