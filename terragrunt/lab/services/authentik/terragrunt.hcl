include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/authentik"
}

inputs = {
  namespace            = "authentik"
  chart_version        = "2025.6.0"
  # authentik_secret_key = TBD — will come from Vault
  # postgresql_password  = TBD — will come from Vault
}
