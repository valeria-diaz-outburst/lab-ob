output "namespace" {
  value = kubernetes_namespace.prometheus.metadata[0].name
}
