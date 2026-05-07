# infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config_bucket"></a> [config\_bucket](#module\_config\_bucket) | ../../s3/bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.config_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.allow_service_linked_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.config_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_sns_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the account for which AWS Config will be configured | `string` | n/a | yes |
| <a name="input_account_suffix"></a> [account\_suffix](#input\_account\_suffix) | The value of this will be suffixed to the account name when constructing the final bucket name | `string` | `""` | no |
| <a name="input_bucket_object_lock_config"></a> [bucket\_object\_lock\_config](#input\_bucket\_object\_lock\_config) | Object lock configuration for when the bucket requires it | <pre>object({<br>    expected_bucket_owner = optional(string)<br>    token                 = optional(string)<br>    default_retention = object({<br>      mode  = string<br>      days  = optional(number)<br>      years = optional(number)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Whether to create an SNS topic for pushing Config notifications | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags to apply to resources created by this module | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the S3 bucket to which config recordings are sent |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic to which config notifications are sent |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
