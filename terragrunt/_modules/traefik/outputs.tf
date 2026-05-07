output "namespace" {
  value = kubernetes_namespace.traefik.metadata[0].name
}

output "release_name" {
  value = helm_release.traefik.name
}

output "release_status" {
  value = helm_release.traefik.status
}
