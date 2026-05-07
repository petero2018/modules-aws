# OpenSearch Role

Creates a Role in OpenSearch.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | >= 2.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | >= 2.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mapping"></a> [mapping](#module\_mapping) | ../role_mapping | n/a |

## Resources

| Name | Type |
|------|------|
| [opensearch_role.role](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_roles"></a> [backend\_roles](#input\_backend\_roles) | A list of backend roles. Which are IAM Roles & Okta groups and users | `list(string)` | `[]` | no |
| <a name="input_cluster_permissions"></a> [cluster\_permissions](#input\_cluster\_permissions) | A list of cluster permissions. | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the role. | `string` | n/a | yes |
| <a name="input_index_permissions"></a> [index\_permissions](#input\_index\_permissions) | A configuration of index permissions. | <pre>list(object({<br>    index_patterns = optional(list(string))<br>    # Document Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/document-level-security/#document-level-security<br>    document_level_security = optional(string)<br>    # Field Level Security: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-level-security/<br>    field_level_security = optional(list(string))<br>    # Field Masking: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/field-masking/<br>    masked_fields = optional(list(string))<br>    # Index Permissions: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/permissions/#indices<br>    allowed_actions = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the security role. | `string` | n/a | yes |
| <a name="input_tenant_permissions"></a> [tenant\_permissions](#input\_tenant\_permissions) | A configuration of tenant permissions | <pre>list(object({<br>    # Tenant patterns: https://opendistro.github.io/for-elasticsearch-docs/docs/security/access-control/multi-tenancy/<br>    tenant_patterns = optional(list(string))<br>    allowed_actions = optional(list(string))<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
