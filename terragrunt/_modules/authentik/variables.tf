variable "namespace" {
  description = "Kubernetes namespace for Authentik"
  type        = string
  default     = "authentik"
}

variable "chart_version" {
  description = "Authentik Helm chart version"
  type        = string
  default     = "2025.6.0"
}

variable "authentik_secret_key" {
  description = "Authentik secret key (required)"
  type        = string
  sensitive   = true
}

variable "postgresql_password" {
  description = "PostgreSQL password for Authentik"
  type        = string
  sensitive   = true
}
