# destination

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_region_settings.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.backup_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_backup_vault_policy.backup_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_policy_document.allow_copy_into_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to retain backups in the vault. | `number` | `15` | no |
| <a name="input_lock_changeable_days"></a> [lock\_changeable\_days](#input\_lock\_changeable\_days) | Number of grace days give to change the vault lock once set. Defaults to 7. | `number` | `7` | no |
| <a name="input_lock_vault"></a> [lock\_vault](#input\_lock\_vault) | Add a vault lock to the vault to prevent backup deletion. | `bool` | `false` | no |
| <a name="input_source_account_id"></a> [source\_account\_id](#input\_source\_account\_id) | AWS Account ID of the account backups will be copied from. | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on AWS Backup related resources. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "disaster-recovery",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_vault_kms_key_arn"></a> [vault\_kms\_key\_arn](#input\_vault\_kms\_key\_arn) | Primary KMS key used to encrypt AWS Backups. | `string` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Name for AWS Backup vaults. | `string` | n/a | yes |
| <a name="input_vault_type"></a> [vault\_type](#input\_vault\_type) | Whether the vault type is regional or a backup. | `string` | `"backup"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_arn"></a> [vault\_arn](#output\_vault\_arn) | ARN associated with the AWS Backup Vault. |
| <a name="output_vault_id"></a> [vault\_id](#output\_vault\_id) | ID associated with the AWS Backup Vault. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
