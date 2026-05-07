# rds

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.rds_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.rds_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identifiers"></a> [identifiers](#input\_identifiers) | RDS Identifier(s) to create group for. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_read_arn"></a> [rds\_read\_arn](#output\_rds\_read\_arn) | ARN of rds\_read IAM group. |
| <a name="output_rds_read_id"></a> [rds\_read\_id](#output\_rds\_read\_id) | ID of rds\_read IAM group. |
| <a name="output_rds_read_name"></a> [rds\_read\_name](#output\_rds\_read\_name) | Name of rds\_read IAM group. |
| <a name="output_rds_write_arn"></a> [rds\_write\_arn](#output\_rds\_write\_arn) | ARN of rds\_write IAM group. |
| <a name="output_rds_write_id"></a> [rds\_write\_id](#output\_rds\_write\_id) | ID of rds\_write IAM group. |
| <a name="output_rds_write_name"></a> [rds\_write\_name](#output\_rds\_write\_name) | Name of rds\_write IAM group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
