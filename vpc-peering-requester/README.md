# vpc-peering-requester

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
| [aws_route.requester_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_tables.requester_vpc_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_owner_id"></a> [accepter\_owner\_id](#input\_accepter\_owner\_id) | Owner ID of the accepting VPC. Leave empty to for peerings in the same account. | `string` | `null` | no |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Accepter region. Leave empty for peerings in the same region. | `string` | `null` | no |
| <a name="input_accepter_vpc_cidr"></a> [accepter\_vpc\_cidr](#input\_accepter\_vpc\_cidr) | CIDR range of the accepting VPC. | `string` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | VPC ID accepting the peering. | `string` | n/a | yes |
| <a name="input_peering_name"></a> [peering\_name](#input\_peering\_name) | Name of the peering connection. | `string` | n/a | yes |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | VPC ID requesting the peering. | `string` | n/a | yes |
| <a name="input_side_tag"></a> [side\_tag](#input\_side\_tag) | Side tag value on peering. | `string` | `"Requester"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | VPC peering connection ID. |
| <a name="output_requester_vpc_cidr_blocks"></a> [requester\_vpc\_cidr\_blocks](#output\_requester\_vpc\_cidr\_blocks) | Requester VPC associated CIDR blocks. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
