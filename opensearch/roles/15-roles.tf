module "role" {
  source = "../role"

  for_each = var.roles

  name                = each.key
  description         = each.value.description
  cluster_permissions = each.value.cluster_permissions != null ? each.value.cluster_permissions : []
  index_permissions   = each.value.index_permissions != null ? each.value.index_permissions : []
  tenant_permissions  = each.value.tenant_permissions != null ? each.value.tenant_permissions : []
  backend_roles       = each.value.backend_roles
}

module "role_mapping" {
  source = "../role_mapping"

  for_each = var.role_mappings

  role_name     = each.key
  backend_roles = each.value
}

module "custom_tenants" {
  source = "../dashboard_tenant"

  for_each = { for k, v in var.tenants : k => v }

  name        = each.key
  description = each.value
}
