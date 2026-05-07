# vpc-peering-options

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
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_remote_vpc_dns_resolution"></a> [allow\_remote\_vpc\_dns\_resolution](#input\_allow\_remote\_vpc\_dns\_resolution) | ALlow remote VPC DNS resolution. | `bool` | `true` | no |
| <a name="input_side"></a> [side](#input\_side) | Side of the VPC peering, can be 'requester', 'accepter' or 'both'. | `string` | n/a | yes |
| <a name="input_vpc_peering_id"></a> [vpc\_peering\_id](#input\_vpc\_peering\_id) | VPC peering ID. The peering must already exist and be accepted. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
