# vpc-peering-accepter

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
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
| [aws_route.accepter_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection_accepter.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_route_tables.accepter_vpc_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | VPC ID accepting the peering. | `string` | n/a | yes |
| <a name="input_peering_connection_id"></a> [peering\_connection\_id](#input\_peering\_connection\_id) | VPC peering connection ID from the requester side. | `string` | n/a | yes |
| <a name="input_peering_name"></a> [peering\_name](#input\_peering\_name) | Name of the peering connection. | `string` | n/a | yes |
| <a name="input_requester_vpc_cidr"></a> [requester\_vpc\_cidr](#input\_requester\_vpc\_cidr) | CIDR range of the accepting VPC. | `string` | n/a | yes |
| <a name="input_side_tag"></a> [side\_tag](#input\_side\_tag) | Side tag value on peering. | `string` | `"Accepter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_peering_connection_id"></a> [vpc\_peering\_connection\_id](#output\_vpc\_peering\_connection\_id) | VPC peering connection ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
