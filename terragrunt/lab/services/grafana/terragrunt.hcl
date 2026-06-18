include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terragrunt/_modules/grafana"
}

inputs = {
  namespace     = "grafana"
}
