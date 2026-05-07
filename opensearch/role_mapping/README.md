# OpenSearch Role Mapping

Maps IAM Roles to OpenSearch Roles.
This is done to allow Fine Grained Access Control into the cluster.
- https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html

## WARNING
This will override existing mappings, so be careful with roles like `all_access`
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

No modules.

## Resources

| Name | Type |
|------|------|
| [opensearch_roles_mapping.mapper](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/roles_mapping) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_roles"></a> [backend\_roles](#input\_backend\_roles) | A list of backend roles. Which are IAM Roles & Okta groups and users | `list(string)` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the OpenSearch security role. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
