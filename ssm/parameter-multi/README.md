# parameter-multi

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_parameter"></a> [parameter](#module\_parameter) | ../parameter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | SSM parameter description. | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | SSM parameters to create, key is the parameter name. | <pre>map(object({<br>    value                 = optional(string, null)<br>    insecure_value        = optional(string, null)<br>    description           = optional(string) # Optional override of the global description variable<br>    type                  = optional(string, "SecureString")<br>    tags                  = optional(map(string), {}) # Will be merged with the global tags variable<br>    sensitive             = optional(bool, true)<br>    dynamic               = optional(bool, false)<br>    dynamic_initial_value = optional(string, "-")<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arns"></a> [arns](#output\_arns) | SSM parameter ARNs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
