# vpc-peering

This module creates a VPC peering between two VPCs in the **same account and region**. If you need to set up a peering cross-region or cross-account, use the `vpc-peering-requester` and `vpc-peering-accepter` modules directly with appropriate providers.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_accepter"></a> [accepter](#module\_accepter) | ../vpc-peering-accepter | n/a |
| <a name="module_accepter_options"></a> [accepter\_options](#module\_accepter\_options) | ../vpc-peering-options | n/a |
| <a name="module_requester"></a> [requester](#module\_requester) | ../vpc-peering-requester | n/a |
| <a name="module_requester_options"></a> [requester\_options](#module\_requester\_options) | ../vpc-peering-options | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.from](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.to](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve DNS in accepter VPC. | `bool` | `true` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | VPC ID accepting the peering. | `string` | n/a | yes |
| <a name="input_peering_name"></a> [peering\_name](#input\_peering\_name) | Name of the peering connection. | `string` | n/a | yes |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve DNS in requester VPC. | `bool` | `true` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | VPC ID creating the peering. | `string` | n/a | yes |
| <a name="input_side_tag"></a> [side\_tag](#input\_side\_tag) | Side tag value on peering. | `string` | `"Both"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
