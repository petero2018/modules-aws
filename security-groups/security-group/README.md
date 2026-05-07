# security-group

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
| [aws_security_group.allow_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | Allow these CIDR blocks. | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | description to give the Security Group. | `string` | `"Allow access from given IPs to the given Port."` | no |
| <a name="input_ipv6_cidr_blocks"></a> [ipv6\_cidr\_blocks](#input\_ipv6\_cidr\_blocks) | Allow these IPv6 CIDR blocks. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the created Security Group. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Port to allow traffic on. | `number` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | IP protocol to allow. Defaults to "tcp". | `string` | `"tcp"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to deploy Security Group to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN for the security group. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID for the security group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
