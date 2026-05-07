# msk-connect

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.72 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.72 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.connect_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.msk_connect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.msk_connect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_mskconnect_connector.connector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_connector) | resource |
| [aws_mskconnect_custom_plugin.plugin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_custom_plugin) | resource |
| [aws_mskconnect_worker_configuration.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_worker_configuration) | resource |
| [aws_iam_policy_document.msk_connect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.msk_connect_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | Retention of the CloudWatch connector logs in days. | `number` | `7` | no |
| <a name="input_connector_mode"></a> [connector\_mode](#input\_connector\_mode) | Preset mode for the connector. | `string` | `"s3"` | no |
| <a name="input_custom_config"></a> [custom\_config](#input\_custom\_config) | Map of configuration parameters to add to the default configuration, string => string. | `map(string)` | n/a | yes |
| <a name="input_custom_config_sensitive"></a> [custom\_config\_sensitive](#input\_custom\_config\_sensitive) | Map of sensitive configuration parameters to add to the default configuration, string => string. | `map(string)` | `{}` | no |
| <a name="input_custom_worker_config"></a> [custom\_worker\_config](#input\_custom\_worker\_config) | Map of worker configuration parameters to add to the default configuration, string => string. | `map(string)` | `{}` | no |
| <a name="input_custom_worker_config_sensitive"></a> [custom\_worker\_config\_sensitive](#input\_custom\_worker\_config\_sensitive) | Map of sensitive worker configuration parameters to add to the default configuration, string => string. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the connector. | `string` | n/a | yes |
| <a name="input_kafka_topics"></a> [kafka\_topics](#input\_kafka\_topics) | List of Kafka topics to write into S3. | `list(string)` | n/a | yes |
| <a name="input_max_tasks_count"></a> [max\_tasks\_count](#input\_max\_tasks\_count) | Maximum number of total Kafka Connect tasks. | `number` | `6` | no |
| <a name="input_max_worker_count"></a> [max\_worker\_count](#input\_max\_worker\_count) | Maximum worker count for autoscaling. | `number` | `2` | no |
| <a name="input_min_worker_count"></a> [min\_worker\_count](#input\_min\_worker\_count) | Minimum worker count for autoscaling. | `number` | `1` | no |
| <a name="input_msk_bootstrap_brokers_tls"></a> [msk\_bootstrap\_brokers\_tls](#input\_msk\_bootstrap\_brokers\_tls) | List of Kafka bootstrap brokers (TLS). | `string` | n/a | yes |
| <a name="input_msk_security_group_ids"></a> [msk\_security\_group\_ids](#input\_msk\_security\_group\_ids) | List of Kafka security groups. | `list(string)` | n/a | yes |
| <a name="input_msk_subnet_ids"></a> [msk\_subnet\_ids](#input\_msk\_subnet\_ids) | List of Kafka subnet IDs. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name that will be added to each Firehose stream. | `string` | n/a | yes |
| <a name="input_output_bucket_arn"></a> [output\_bucket\_arn](#input\_output\_bucket\_arn) | ARN of the S3 bucket to store the events. | `string` | `null` | no |
| <a name="input_output_bucket_name"></a> [output\_bucket\_name](#input\_output\_bucket\_name) | Name of the S3 bucket to store the events. | `string` | `null` | no |
| <a name="input_plugin_bucket_arn"></a> [plugin\_bucket\_arn](#input\_plugin\_bucket\_arn) | ARN of the bucket used to store Kafka Connect plugins. | `string` | n/a | yes |
| <a name="input_plugin_path"></a> [plugin\_path](#input\_plugin\_path) | S3 object path of the plugin to use in the connector. | `string` | n/a | yes |
| <a name="input_scale_in_cpu_percentage"></a> [scale\_in\_cpu\_percentage](#input\_scale\_in\_cpu\_percentage) | Autoscaling: CPU percentage at which to scale in. | `number` | `40` | no |
| <a name="input_scale_out_cpu_percentage"></a> [scale\_out\_cpu\_percentage](#input\_scale\_out\_cpu\_percentage) | Autoscaling: CPU percentage at which to scale out. | `number` | `80` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | n/a | yes |
| <a name="input_worker_mcu_count"></a> [worker\_mcu\_count](#input\_worker\_mcu\_count) | MCU count per worker: 1 MCU = 1 vCPU + 4 GiB memory. | `number` | `1` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
