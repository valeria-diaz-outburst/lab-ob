include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/prometheus"
}

inputs = {
  namespace     = "prometheus"
}
