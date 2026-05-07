# secure-parameters

Provision a list of SecureString SSM parameters with a given value and description.

Serves to take "manual SSM secrets" issue under the code control:

* joins scattered/duplicated manually created parameters under Terraform/Atlantis umbrella;
* ensure they all are created as `SecureString` (some manually created are just `String`);

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.secure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the secure SSM parameters. | `string` | n/a | yes |
| <a name="input_names"></a> [names](#input\_names) | Names of the secure SSM parameters to be provisioned [with passed value]. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | Value of the secure SSM parameters to provision. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_names"></a> [names](#output\_names) | Names of the created SSM parameters. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
