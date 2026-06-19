resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        container {
          image = "prom/prometheus:latest"
          name = "prometheus"

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/prometheus"
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.prometheus.metadata[0].name
          }
        }
      }
    }

    replicas = 1
  }
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      name = "http"
      port = 80
      target_port = 9090
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.prometheus]
}

resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "prometheus-config"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }

  data = {
    "prometheus.yml" = <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "grafana"
    static_configs:
      - targets: ["grafana.grafana.svc.cluster.local:80"]
EOF
  }
}


