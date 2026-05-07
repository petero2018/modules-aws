# iam-role
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
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
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.creation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | Policy that grants an entity permission to assume the role. | `string` | n/a | yes |
| <a name="input_attach_policies"></a> [attach\_policies](#input\_attach\_policies) | List of existing IAM policy ARNs to attach to the IAM role. | `list(string)` | `[]` | no |
| <a name="input_create_policies"></a> [create\_policies](#input\_create\_policies) | Inline IAM policies (<NAME>:<POLICY>) to create and attach to the IAM role. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the role. | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Specifies to force detaching any policies the role has before destroying it. | `bool` | `false` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration (in seconds). | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM role to create. | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to the role. | `string` | `null` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify resource ownership. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Role ARN. |
| <a name="output_name"></a> [name](#output\_name) | Role name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
