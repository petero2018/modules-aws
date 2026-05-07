resource "opensearch_roles_mapping" "mapper" {
  role_name     = var.role_name
  backend_roles = var.backend_roles
}
