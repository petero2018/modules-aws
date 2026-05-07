# vpc


## Example Usage

```hcl
module "example-vpc" {
  source = "git@github.com:powise/terraform-modules//aws/vpc?ref=aws-vpc-0.3.3"

  vpc_name                  = "VPC_Name"
  cidr_block                = "172.17.48.0/20"
  single_public_route_table = true
  enable_wazuh_endpoint     = false
  enable_service_gateways   = true
  create_vpc_policy         = false
  enable_flow_logs          = true

  subnets = {
    # Public subnets
    cidrsubnet("172.17.48.0/20", 3, 0) = {    # 172.17.48.0/23
      az        = "us-east-1a"
      is_public = true
    },
    cidrsubnet("172.17.48.0/20", 3, 1) = {    # 172.17.50.0/23
      az        = "us-east-1b"
      is_public = true
    },
    cidrsubnet("172.17.48.0/20", 3, 2) = {    # 172.17.52.0/23
      az        = "us-east-1c"
      is_public = true
    },
    # Private subnets
    cidrsubnet("172.17.48.0/20", 3, 3) = {    # 172.17.54.0/23
      az        = "us-east-1a"
      is_public = false
    },
    cidrsubnet("172.17.48.0/20", 3, 4) = {    # 172.17.56.0/23
      az        = "us-east-1b"
      is_public = false
    },
    cidrsubnet("172.17.48.0/20", 3, 5) = {    # 172.17.58.0/23
      az        = "us-east-1c"
      is_public = false
    },
  }

  vpc_tags = {
    "Key" = "Value"
  }
  private_subnet_tags = {
    "Key" = "Value"
  }
  public_subnet_tags = {
    "Key" = "Value"
  }

  tags = {
    team    = "product-infrastructure",
    service = "vpc",
    impact  = "high"
  }
}
```

> This module runs validation checks on tags so the the following tags must be supplied: `team`, `service` and `impact`
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent_endpoint"></a> [agent\_endpoint](#module\_agent\_endpoint) | ../../security/wazuh-endpoint | n/a |
| <a name="module_aws_service_endpoint"></a> [aws\_service\_endpoint](#module\_aws\_service\_endpoint) | ../vpc-endpoint | n/a |
| <a name="module_datadog_endpoint"></a> [datadog\_endpoint](#module\_datadog\_endpoint) | ../../aws/vpc-endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default_deny](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.vpc_cidr_restriction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_internet_gateway.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.nat_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.nat_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.dynamodb_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vpc_cidr_restriction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_service_endpoints"></a> [aws\_service\_endpoints](#input\_aws\_service\_endpoints) | AWS Services to create vpc endpoints. | `map(string)` | `{}` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR Range of the network. | `string` | n/a | yes |
| <a name="input_create_vpc_policy"></a> [create\_vpc\_policy](#input\_create\_vpc\_policy) | Create a policy to restrict access to the VPC CIDR. | `bool` | `false` | no |
| <a name="input_destination_options"></a> [destination\_options](#input\_destination\_options) | Destination options for a flow log. | <pre>object({<br>    file_format                = string<br>    hive_compatible_partitions = bool<br>    per_hour_partition         = bool<br>  })</pre> | <pre>{<br>  "file_format": "plain-text",<br>  "hive_compatible_partitions": false,<br>  "per_hour_partition": true<br>}</pre> | no |
| <a name="input_enable_datadog_endpoints"></a> [enable\_datadog\_endpoints](#input\_enable\_datadog\_endpoints) | Enable Datadog private endpoints, only valid in us-east-1. | `bool` | `false` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Capture VPC flow traffic. | `bool` | `false` | no |
| <a name="input_enable_service_gateways"></a> [enable\_service\_gateways](#input\_enable\_service\_gateways) | Enable S3 and DynamoDB gateways on the VPC. | `bool` | `true` | no |
| <a name="input_enable_wazuh_endpoint"></a> [enable\_wazuh\_endpoint](#input\_enable\_wazuh\_endpoint) | Create an endpoint for wazuh agents to communicate with the manager in the security account. | `bool` | `true` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | Field formatting for VPC flow logs. | `string` | `"${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status} ${vpc-id} ${subnet-id} ${instance-id} ${tcp-flags} ${pkt-srcaddr} ${pkt-dstaddr} ${type} ${region} ${az-id} ${sublocation-type} ${sublocation-id} ${pkt-src-aws-service} ${pkt-dst-aws-service} ${flow-direction} ${traffic-path}"` | no |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | The path of the policy in IAM. | `string` | `"/"` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Extra tags to be applied to private subnets. | `map(string)` | `{}` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Extra tags to be applied to public subnets. | `map(string)` | `{}` | no |
| <a name="input_single_public_route_table"></a> [single\_public\_route\_table](#input\_single\_public\_route\_table) | Use a single route table for public subnets instead of one per subnet. | `bool` | `false` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create. Key is the CIDR range of the subnet. | <pre>map(object({<br>    az                = string,<br>    is_public         = bool,<br>    extra_tags        = optional(map(string)),<br>    use_for_endpoints = optional(bool, false), # Only one subnet per AZ can have this enabled<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC. | `string` | n/a | yes |
| <a name="input_vpc_source_ips"></a> [vpc\_source\_ips](#input\_vpc\_source\_ips) | Source IP addresses to restrict access to the VPC. | `list(string)` | `[]` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Extra tags to be applied to the VPC resource. | `map(string)` | `{}` | no |
| <a name="input_wazuh_endpoint_service_name"></a> [wazuh\_endpoint\_service\_name](#input\_wazuh\_endpoint\_service\_name) | The endpoint service name to be used for the VPC endpoint. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | AWS account ID where the VPC is created. |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region name where the VPC is created. |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | CIDR block of the VPC. |
| <a name="output_nat_gateway_private_ips"></a> [nat\_gateway\_private\_ips](#output\_nat\_gateway\_private\_ips) | List of NAT gateways private IPs. |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of NAT gateways public IPs. |
| <a name="output_nat_gateway_public_ips_cidr"></a> [nat\_gateway\_public\_ips\_cidr](#output\_nat\_gateway\_public\_ips\_cidr) | List of NAT gateways public IPs as CIDR (/32). |
| <a name="output_private_extended_subnets"></a> [private\_extended\_subnets](#output\_private\_extended\_subnets) | Full private extended subnets data. |
| <a name="output_private_extended_subnets_ids"></a> [private\_extended\_subnets\_ids](#output\_private\_extended\_subnets\_ids) | List of private extended subnet IDs. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Full private subnets data. |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | List of private subnet IDs. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Full public subnet data. |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | List of public subnet IDs. |
| <a name="output_vpc_cidr_policy_arn"></a> [vpc\_cidr\_policy\_arn](#output\_vpc\_cidr\_policy\_arn) | ARN of created VPC policy. If create\_vpc\_policy not set, defaults to null. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of created VPC network. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
