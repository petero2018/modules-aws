# index_templates

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | >= 2.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opensearch_composable_index_template.template](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/composable_index_template) | resource |
| [opensearch_dashboard_object.index_pattern](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/dashboard_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_index_patterns"></a> [index\_patterns](#input\_index\_patterns) | Map of index pattern => time field name to create. | `map(string)` | `{}` | no |
| <a name="input_index_templates"></a> [index\_templates](#input\_index\_templates) | Map of name => JSON index template to create. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
