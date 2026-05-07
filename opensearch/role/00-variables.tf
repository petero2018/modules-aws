################################################################################
# OpenSearch Role
################################################################################

variable "name" {
  type = string

  description = "The name of the security role."
}

variable "description" {
  type = string

  description = "Description of the role."
}

################################################################################
# Cluster Permissions
################################################################################

variable "cluster_permissions" {
  type = list(string)

  # Cluster Permissions: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/permissions/#cluster
  default     = []
  description = "A list of cluster permissions."
}

################################################################################
# Index Permissions
################################################################################

variable "index_permissions" {
  type = list(object({
    index_patterns = optional(list(string))
    # Document Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/document-level-security/#document-level-security
    document_level_security = optional(string)
    # Field Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-level-security/
    field_level_security = optional(list(string))
    # Field Masking: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-masking/
    masked_fields = optional(list(string))
    # Index Permissions: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/permissions/#indices
    allowed_actions = optional(list(string))
  }))

  default     = []
  description = "A configuration of index permissions."
}

################################################################################
# Index Permissions
################################################################################

variable "tenant_permissions" {
  type = list(object({
    # Tenant patterns: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/multi-tenancy/
    tenant_patterns = optional(list(string))
    allowed_actions = optional(list(string))
  }))

  default     = []
  description = "A configuration of tenant permissions"
}

################################################################################
# Role Mapping
################################################################################

variable "backend_roles" {
  type = list(string)

  default     = []
  description = "A list of backend roles. Which are IAM Roles & Okta groups and users"
}
