# redis-cluster-multi

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
| <a name="module_elasticache"></a> [elasticache](#module\_elasticache) | ../redis-cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_subnet_group.clusters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group_rule.redis_ingress_from_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Configuration of the clusters. | <pre>map(object({<br>    instance_type       = string,<br>    version             = string,<br>    parameter_group     = optional(string, "default"),<br>    tag_team            = string,<br>    tag_service         = string,<br>    tag_impact          = string,<br>    security_group_name = optional(string),<br>    dns_name            = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_create_resources"></a> [create\_resources](#input\_create\_resources) | Enable to actually create resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g. 'tfprod'). | `string` | n/a | yes |
| <a name="input_open_cidr_blocks"></a> [open\_cidr\_blocks](#input\_open\_cidr\_blocks) | List of CIDR blocks to open access from. | `list(string)` | n/a | yes |
| <a name="input_private_subnets_ids"></a> [private\_subnets\_ids](#input\_private\_subnets\_ids) | List of private subnets IDs. | `list(string)` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to create records in. | `string` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Specify directly the subnet group name. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on AWS Backup related resources. | `map(string)` | <pre>{<br>  "impact": "high",<br>  "service": "redis",<br>  "team": "product-infrastructure"<br>}</pre> | no |
| <a name="input_upgrade_old_instance_types"></a> [upgrade\_old\_instance\_types](#input\_upgrade\_old\_instance\_types) | Override node\_type with a newer instance type if possible (e.g. from m3 to m5). | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the clusters in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_address"></a> [cluster\_address](#output\_cluster\_address) | Address of the first cache node for each cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
