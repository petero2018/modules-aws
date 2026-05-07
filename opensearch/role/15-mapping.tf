module "mapping" {
  source = "../role_mapping"

  count = length(var.backend_roles) > 0 ? 1 : 0

  role_name = var.name

  backend_roles = var.backend_roles

  depends_on = [opensearch_role.role]
}
