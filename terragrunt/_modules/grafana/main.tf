resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          image = "grafana/grafana:latest"
          name = "grafana"

          port {
            container_port = 3000
          }
        }
      }
    }

    replicas = 1
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      name = "http"
      port = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.grafana]
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    ingress_class_name = "traefik"

    rule {
      host = "grafana.lab"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.grafana.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.grafana]
}
