output "namespace" {
  value = kubernetes_namespace.deployment.metadata[0].name
}

output "release_name" {
  value = helm_release.authentik.name
}

output "release_status" {
  value = helm_release.authentik.status
}
