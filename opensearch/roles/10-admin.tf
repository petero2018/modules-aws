module "admin_mapping" {
  source = "../role_mapping"

  count = length(var.admin_backend_roles) > 0 ? 1 : 0

  role_name     = "all_access"
  backend_roles = var.admin_backend_roles
}
