# role

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
| [aws_iam_role.main_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.main_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.allow_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name for AWS Backup role. | `string` | `"AWSBackupRole"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on the IAM Role. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "disaster-recovery",<br>  "team": "product-infrastructure"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_role_arn"></a> [backup\_role\_arn](#output\_backup\_role\_arn) | Backup IAM Role ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
