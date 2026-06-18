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

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.grafana]
}
