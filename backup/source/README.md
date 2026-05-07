# source

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~>2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~>2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db_export_bucket"></a> [db\_export\_bucket](#module\_db\_export\_bucket) | git@github.com:powise/terraform-modules//aws/s3/bucket | aws-s3-bucket-2.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_framework.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework) | resource |
| [aws_backup_framework.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework) | resource |
| [aws_backup_plan.clickhouse_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.dynamodb_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.rds_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.s3_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_region_settings.region_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_selection.clickhouse_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.dynamodb_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.rds_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.s3_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_cloudwatch_event_rule.backup_completed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_rds_copy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda_rds_copy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_rds_copy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.snapshot_export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.export_snapshots_to_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_rds_copy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.rds_backup_copy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.allow_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.export_snapshots_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_rds_copy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_account_id"></a> [backup\_account\_id](#input\_backup\_account\_id) | AWS Account ID for the backup account. | `number` | n/a | yes |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to retain backups in the vault. | `number` | `15` | no |
| <a name="input_backup_role_arn"></a> [backup\_role\_arn](#input\_backup\_role\_arn) | ARN of the IAM role used for AWS Backup. | `string` | n/a | yes |
| <a name="input_backup_vault_arn"></a> [backup\_vault\_arn](#input\_backup\_vault\_arn) | ARN for the AWS Backup Vault in the region backups are copied to in the main account. | `string` | n/a | yes |
| <a name="input_destination_region"></a> [destination\_region](#input\_destination\_region) | Region to copy backups to in main account. | `string` | n/a | yes |
| <a name="input_destination_region_vault_arn"></a> [destination\_region\_vault\_arn](#input\_destination\_region\_vault\_arn) | ARN for the AWS Backup Vault in the region backups are copied to in the main account. | `string` | n/a | yes |
| <a name="input_dynamodb_selection_tag"></a> [dynamodb\_selection\_tag](#input\_dynamodb\_selection\_tag) | Value for tag to target DynamoDB resources for backups. Defaults to "dynamodb\_daily" | `string` | `"dynamodb_daily"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. | `string` | n/a | yes |
| <a name="input_rds_selection_tag"></a> [rds\_selection\_tag](#input\_rds\_selection\_tag) | Value for tag to target RDS resources for backups. Defaults to "rds\_daily" | `string` | `"rds_daily"` | no |
| <a name="input_s3_selection_tag"></a> [s3\_selection\_tag](#input\_s3\_selection\_tag) | Value for tag to target S3 resources for backups. Defaults to "s3\_backup" | `string` | `"s3_backup"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on AWS Backup related resources. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "disaster-recovery",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_vault_kms_key_arn"></a> [vault\_kms\_key\_arn](#input\_vault\_kms\_key\_arn) | Primary KMS key used to encrypt AWS Backups. | `string` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Name for AWS Backup vaults. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
