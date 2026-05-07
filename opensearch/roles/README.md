# roles

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | >= 2.3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_admin_mapping"></a> [admin\_mapping](#module\_admin\_mapping) | ../role_mapping | n/a |
| <a name="module_custom_tenants"></a> [custom\_tenants](#module\_custom\_tenants) | ../dashboard_tenant | n/a |
| <a name="module_role"></a> [role](#module\_role) | ../role | n/a |
| <a name="module_role_mapping"></a> [role\_mapping](#module\_role\_mapping) | ../role_mapping | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_backend_roles"></a> [admin\_backend\_roles](#input\_admin\_backend\_roles) | Admin Backend Roles to attach to all\_access | `list(string)` | `[]` | no |
| <a name="input_role_mappings"></a> [role\_mappings](#input\_role\_mappings) | List of role mappings to create (e.g. existing default roles to Okta backend roles). | `map(list(string))` | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles to create and attach to backend roles | <pre>map(object({<br>    description         = string<br>    cluster_permissions = optional(list(string))<br>    index_permissions = optional(list(object({<br>      index_patterns = optional(list(string))<br>      # Document Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/document-level-security/#document-level-security<br>      document_level_security = optional(string)<br>      # Field Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-level-security/<br>      field_level_security = optional(list(string))<br>      # Field Masking: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-masking/<br>      masked_fields = optional(list(string))<br>      # Index Permissions: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/permissions/#indices<br>      allowed_actions = optional(list(string))<br>    })))<br>    tenant_permissions = optional(list(object({<br>      # Tenant patterns: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/multi-tenancy/<br>      tenant_patterns = optional(list(string))<br>      allowed_actions = optional(list(string))<br>    })))<br>    backend_roles = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tenants"></a> [tenants](#input\_tenants) | Map of tenants names to their descriptions. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
