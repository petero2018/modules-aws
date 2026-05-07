# redis cluster
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
| [aws_elasticache_cluster.redis_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_parameter_group.redis_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_route53_record.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.redis_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_parameter_group"></a> [default\_parameter\_group](#input\_default\_parameter\_group) | Default parameter group to apply if none provided. Mapped to redis version. | `map(string)` | <pre>{<br>  "2.8.19": "default.redis2.8",<br>  "2.8.21": "default.redis2.8",<br>  "2.8.24": "default.redis2.8",<br>  "2.8.33": "default.redis2.8",<br>  "2.8.6": "default.redis2.8",<br>  "3.2.4": "default.redis3.2",<br>  "6.0": "default.redis6.x",<br>  "6.0.5": "default.redis6.x",<br>  "6.2": "default.redis6.x",<br>  "6.x": "default.redis6.x",<br>  "7.0": "default.redis7",<br>  "7.1": "default.redis7"<br>}</pre> | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Route53 custom name in the zone, optional. | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes. (https://aws.amazon.com/es/elasticache/details/#Available_Cache_Node_Types) | `string` | n/a | yes |
| <a name="input_open_cidr_blocks"></a> [open\_cidr\_blocks](#input\_open\_cidr\_blocks) | List of CIDR that can access the cluster. | `list(string)` | `[]` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Use 'default' to use the deafult parameter group. Use any other string to define a parameter group (in this case you should define the parameter group variables, if any). | `string` | `"default"` | no |
| <a name="input_redis_name"></a> [redis\_name](#input\_redis\_name) | Name of the redis cluster. | `string` | n/a | yes |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Avalable values: 6.0.5, 3.2.4, 2.8.24, 2.8.33, 2.8.22, 2.8.21, 2.8.19, 2.8.6 | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to create records in. | `string` | `null` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description of security group to create. | `string` | `"Managed by Terraform"` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of security group to create (optional). | `string` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the subnet group to be used for the cache cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_upgrade_old_instance_types"></a> [upgrade\_old\_instance\_types](#input\_upgrade\_old\_instance\_types) | Override node\_type with a newer instance type if possible (e.g. from m3 to m5). | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC where the security group belongs. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_address"></a> [cluster\_address](#output\_cluster\_address) | Address of the first cache node. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group id for Redis Cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
