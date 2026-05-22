variable "namespace" {
  description = "Kubernetes namespace for Vault"
  type        = string
  default     = "deployment"
}

variable "chart_version" {
  description = "Vault Helm chart version"
  type        = string
  default     = "0.29.1"
}

variable "storage_size" {
  description = "PVC size for Vault data storage"
  type        = string
  default     = "1Gi"
}
