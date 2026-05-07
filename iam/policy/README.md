# iam-policy
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
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
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM role to create. | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to the role. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy document. This is a JSON formatted string. | `string` | n/a | yes |
| <a name="input_roles_to_attach"></a> [roles\_to\_attach](#input\_roles\_to\_attach) | Roles to attach policy. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resources ownership | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Policy ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
