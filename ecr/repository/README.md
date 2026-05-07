# repository

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cmk"></a> [cmk](#module\_cmk) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorised_accounts"></a> [authorised\_accounts](#input\_authorised\_accounts) | A list of AWS Account IDs which are allowed to pull from this repository. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ECR repository to create. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |
| <a name="input_use_additional_source_account_check"></a> [use\_additional\_source\_account\_check](#input\_use\_additional\_source\_account\_check) | If set to true, an extra IAM conditional is added to offer additional protection for cross-account ECR repositories. It requires that the calling service sends the aws:SourceAccount condition key in requests to ECR. | `bool` | `false` | no |
| <a name="input_use_immutable_image_tags"></a> [use\_immutable\_image\_tags](#input\_use\_immutable\_image\_tags) | Whether image tags are able to be overwritten. Tag immutability is recommended. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The full ARN of the ECR repository. |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The URL of the ECR repository. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
