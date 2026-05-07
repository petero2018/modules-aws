################################################################################
# Admin Backend Roles
################################################################################

variable "admin_backend_roles" {
  type = list(string)

  default     = []
  description = "Admin Backend Roles to attach to all_access"
}

################################################################################
# Roles
################################################################################

variable "roles" {
  type = map(object({
    description         = string
    cluster_permissions = optional(list(string))
    index_permissions = optional(list(object({
      index_patterns = optional(list(string))
      # Document Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/document-level-security/#document-level-security
      document_level_security = optional(string)
      # Field Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-level-security/
      field_level_security = optional(list(string))
      # Field Masking: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-masking/
      masked_fields = optional(list(string))
      # Index Permissions: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/permissions/#indices
      allowed_actions = optional(list(string))
    })))
    tenant_permissions = optional(list(object({
      # Tenant patterns: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/multi-tenancy/
      tenant_patterns = optional(list(string))
      allowed_actions = optional(list(string))
    })))
    backend_roles = list(string)
  }))

  default     = {}
  description = "Roles to create and attach to backend roles"
}

variable "role_mappings" {
  type        = map(list(string))
  default     = {}
  description = "List of role mappings to create (e.g. existing default roles to Okta backend roles)."
}

variable "tenants" {
  type    = map(string)
  default = {}

  description = "Map of tenants names to their descriptions."
}
