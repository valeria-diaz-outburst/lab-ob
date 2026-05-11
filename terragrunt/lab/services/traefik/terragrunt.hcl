include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/traefik"
}

inputs = {
  namespace     = "traefik"
  chart_version = "28.0.0"
  values_yaml   = <<EOF
service:
  type: LoadBalancer

ingressClass:
  enabled: true
  isDefaultClass: true

ports:
  web:
    port: 80
    expose:
      default: true
  websecure:
    port: 443
    expose:
      default: true

securityContext:
  capabilities:
    add:
      - NET_BIND_SERVICE
    drop:
      - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: false
  runAsUser: 0
EOF
}
