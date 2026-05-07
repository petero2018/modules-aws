# parameter

## Parameters vs Dynamic Parameters

Marking a parameter as "dynamic" will resut in Terraform ignoring changes to the parameter's `value` (or `insecure_value`)

Because lifecycle rules in Terraform are themselves static, this mean creating a separate resource for dynamic values. If at some point you need to migrate a previously dynamic value to a fixed value (or vice versa), you can use a `moved` block:

```terraform
# Moving from a dynamic value to a static one - i.e. making Terraform control the value
moved {
  from = module.my_param.aws_ssm_parameter.parameter_dynamic[0]
  to   = module.my_param.aws_ssm_parameter.parameter[0]
}
```

Remember to populate the `value` (or `insecure_value`) to stop Terraform from wiping out the existing value.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.parameter_dynamic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | SSM parameter description. | `string` | n/a | yes |
| <a name="input_dynamic"></a> [dynamic](#input\_dynamic) | Whether the SSM parameter's value will be managed outside of Terraform or not. | `bool` | `false` | no |
| <a name="input_dynamic_initial_value"></a> [dynamic\_initial\_value](#input\_dynamic\_initial\_value) | The initial value to set when creating a dynamic SSM parameter, which will be thereafter replaced by an external process. | `string` | `"-"` | no |
| <a name="input_insecure_value"></a> [insecure\_value](#input\_insecure\_value) | Insecure SSM parameter value. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | SSM parameter name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | SSM parameter type. | `string` | `"SecureString"` | no |
| <a name="input_value"></a> [value](#input\_value) | SSM parameter value. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SSM parameter ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
