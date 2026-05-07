# VPN Endpoint
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.vpn_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_client_vpn_authorization_rule.authorization_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_authorization_rule.authorization_route_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.powise_client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.powise_client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.powise_client_vpn_route_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_ec2_client_vpn_route.powise_client_vpn_route_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_ec2_client_vpn_route.powise_client_vpn_route_subnet_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_iam_saml_provider.okta](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_kms_key.vpn_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_acm_certificate.powise_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | Routes to authorize to OKTA groups | <pre>map(object({<br>    cidr   = string       # CIDR of the peering<br>    groups = list(string) # Allowed OKTA groups with access to this peering<br>  }))</pre> | `{}` | no |
| <a name="input_authorization_rules_all"></a> [authorization\_rules\_all](#input\_authorization\_rules\_all) | CIDRs authorized to all users. key: name, value: CIDR. | `map(string)` | `{}` | no |
| <a name="input_certificate_domain"></a> [certificate\_domain](#input\_certificate\_domain) | Certificate to use on the VPN endpoint. | `string` | `"*.powise.tf"` | no |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | CIDR Block used by the VPN Clients. | `string` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers used by VPN Client. By default the VPC DNS Server. | `list(string)` | `[]` | no |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Logs retention. | `number` | `365` | no |
| <a name="input_name"></a> [name](#input\_name) | VPN Endpoint name. | `string` | n/a | yes |
| <a name="input_okta_metadata_document"></a> [okta\_metadata\_document](#input\_okta\_metadata\_document) | OKTA Metadata Document | `string` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags to be used to identify private subnets. | `map(string)` | <pre>{<br>  "tier": "private"<br>}</pre> | no |
| <a name="input_saml_provider_name"></a> [saml\_provider\_name](#input\_saml\_provider\_name) | Name of IAM SAML Provider | `string` | `"okta"` | no |
| <a name="input_self_service_portal"></a> [self\_service\_portal](#input\_self\_service\_portal) | Indicates whether the self-service portal is enabled. | `string` | `"disabled"` | no |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | Indicates whether split-tunnel is enabled on VPN endpoint. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC for VPN. | `string` | n/a | yes |
| <a name="input_vpn_routes"></a> [vpn\_routes](#input\_vpn\_routes) | CIDRs to route to the VPN. | <pre>map(object({<br>    cidr        = string<br>    description = string<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
