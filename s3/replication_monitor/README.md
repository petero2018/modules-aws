# replication_monitor

This module sets up a datadog monitor and required resources to send a notification when the replication fails between 2 s3 buckets.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_monitor_s3_replication_failures"></a> [monitor\_s3\_replication\_failures](#module\_monitor\_s3\_replication\_failures) | git@github.com:powise/terraform-modules//datadog/monitors | datadog-monitors-1.0.0 |
| <a name="module_sns_kms_sse"></a> [sns\_kms\_sse](#module\_sns\_kms\_sse) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.0.3 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_notification.s3_replication_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic.s3_replication_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.s3_replication_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.s3_replication_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_kms_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | ARN of the bucket you wish to monitor. This is the source bucket that is being replicated. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket you wish to monitor. This is the source bucket that is being replicated. | `string` | n/a | yes |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key to use to call datadog's api. | `string` | `null` | no |
| <a name="input_monitor_name"></a> [monitor\_name](#input\_monitor\_name) | To override the default monitor name that will assume the bucket\_name by default. Use this if the bucket name contains special characters. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
