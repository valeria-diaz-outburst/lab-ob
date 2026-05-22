include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/vault"
}

inputs = {
  namespace     = "deployment"
  chart_version = "0.29.1"
  storage_size  = "1Gi"
}
