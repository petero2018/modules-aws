# tenant

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
| [opensearch_dashboard_tenant.custom_tenant](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/dashboard_tenant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of a dashboard custom tenant. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the custom dashboard tenant. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
