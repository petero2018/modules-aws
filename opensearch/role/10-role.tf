resource "opensearch_role" "role" {
  role_name   = var.name
  description = var.description

  cluster_permissions = var.cluster_permissions

  dynamic "index_permissions" {
    for_each = toset(var.index_permissions)
    content {
      index_patterns          = index_permissions.value.index_patterns
      document_level_security = index_permissions.value.document_level_security
      field_level_security    = index_permissions.value.field_level_security
      masked_fields           = index_permissions.value.masked_fields
      allowed_actions         = index_permissions.value.allowed_actions
    }
  }

  dynamic "tenant_permissions" {
    for_each = toset(var.tenant_permissions)
    content {
      tenant_patterns = tenant_permissions.value.tenant_patterns
      allowed_actions = tenant_permissions.value.allowed_actions
    }
  }
}
