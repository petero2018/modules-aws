# table

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_readwrite_policy"></a> [readwrite\_policy](#module\_readwrite\_policy) | git@github.com:powise/terraform-modules//aws/iam/policy | aws-iam-policy-0.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy_document.readwrite](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Map of attributes: name => type. Type must be 'S' (string), 'N' (number) or 'B' (boolean). | `map(string)` | `{}` | no |
| <a name="input_aws_backup_enabled"></a> [aws\_backup\_enabled](#input\_aws\_backup\_enabled) | Adds a new tag to enable AWS daily backups. | `bool` | `false` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | The billing mode for the table. Must be 'PROVISIONED' or 'PAY\_PER\_REQUEST'. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_create_iam_readwrite_policy"></a> [create\_iam\_readwrite\_policy](#input\_create\_iam\_readwrite\_policy) | Whether to create an IAM read/write policy for this table. | `bool` | `false` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Whether to enable point in time recovery. | `bool` | `false` | no |
| <a name="input_global_secondary_indices"></a> [global\_secondary\_indices](#input\_global\_secondary\_indices) | Map of global secondary indices: name => settings. | <pre>map(object({<br>    hash_key        = string,<br>    projection_type = string,<br>  }))</pre> | `{}` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Table hash key. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table. | `string` | n/a | yes |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Table range key (optional). | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Read capacity units. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Optional TTL settings. | <pre>object({<br>    attribute_name = optional(string)<br>    enabled        = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Write capacity units. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the table. |
| <a name="output_iam_readwrite_policy_arn"></a> [iam\_readwrite\_policy\_arn](#output\_iam\_readwrite\_policy\_arn) | ARN of the IAM read/write policy for this table, if created. |
| <a name="output_id"></a> [id](#output\_id) | Name of the table. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
