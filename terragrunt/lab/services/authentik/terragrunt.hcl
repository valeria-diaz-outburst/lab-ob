include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/authentik"
}

inputs = {
  namespace     = "authentik"
  chart_version = "2024.12.3"
}
