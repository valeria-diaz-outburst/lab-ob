output "namespace" {
  value = kubernetes_namespace.deployment.metadata[0].name
}

output "release_name" {
  value = helm_release.vault.name
}

output "release_status" {
  value = helm_release.vault.status
}

output "vault_address" {
  value       = "http://vault.${kubernetes_namespace.deployment.metadata[0].name}.svc.cluster.local:8200"
  description = "Internal cluster address for Vault"
}
