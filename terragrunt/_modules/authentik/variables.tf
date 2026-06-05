variable "namespace" {
  description = "Kubernetes namespace for Authentik"
  type        = string
  default     = "authentik"
}

variable "chart_version" {
  description = "Authentik Helm chart version"
  type        = string
  default     = "2024.12.3"
}

