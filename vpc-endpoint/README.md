# vpc


## Example Usage

```hcl

```

> This module runs validation checks on tags so the the following tags must be supplied: `team`, `service` and `impact`
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
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
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_route_tables.tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.endpoint_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | The VPC endpoint type: Gateway, GatewayLoadBalancer, or Interface. | `string` | `"Interface"` | no |
| <a name="input_extra_cidr"></a> [extra\_cidr](#input\_extra\_cidr) | Additional CIDR range to be specified in the security group. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | VPC Endpoint name. By default the service name. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | A policy to attach to the endpoint that controls access to the service. Defaults to full access. | `string` | `null` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Whether or not the VPC is associated with a private hosted zone. | `bool` | `false` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | One or more route table IDs. Applicable for endpoints of type Gateway. By default all VPC tables. | `list(string)` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The ID of one or more security groups to associate with the network interface. By default creates one for access in the VPC. | `list(string)` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The service name. FQDN if is not an AWS service. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of one or more subnets in which to create a network interface for the endpoint. By default the private ones. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Required ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint. |
| <a name="output_dns_entry"></a> [dns\_entry](#output\_dns\_entry) | The DNS entries for the VPC Endpoint. Applicable for endpoints of type Interface. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint. |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type Interface. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
