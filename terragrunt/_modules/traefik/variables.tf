variable "namespace" {
  description = "Kubernetes namespace for Traefik"
  type        = string
  default     = "traefik"
}

variable "chart_version" {
  description = "Traefik Helm chart version"
  type        = string
  default     = "28.0.0"
}

variable "values_yaml" {
  description = "Additional Helm values as a YAML string"
  type        = string
  default     = ""
}
