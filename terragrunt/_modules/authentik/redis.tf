resource "kubernetes_deployment_v1" "redis" {
  metadata {
    name      = "authentik-redis"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "authentik-redis" } }
    template {
      metadata { labels = { app = "authentik-redis" } }
      spec {
        container {
          name  = "redis"
          image = "redis:7-alpine"
          port  { container_port = 6379 }
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
    selector = { app = "authentik-redis" }
    port { port = 6379, target_port = 6379 }
  }
}