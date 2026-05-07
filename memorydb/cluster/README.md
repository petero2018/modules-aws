# redis-cluster-multi

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
| [aws_iam_policy.memorydb_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy.memorydb_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_memorydb_acl.iamacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_acl) | resource |
| [aws_memorydb_cluster.memorydb_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_cluster) | resource |
| [aws_memorydb_parameter_group.memorydb_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_parameter_group) | resource |
| [aws_memorydb_user.iamuser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_user) | resource |
| [aws_route53_record.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.memorydb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.memorydb_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_name"></a> [acl\_name](#input\_acl\_name) | The name of the Access Control List to associate with the cluster. | `string` | `"open-access"` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that automatic minor version upgrades are allowed. They will be performed during the maintenance window. | `bool` | `false` | no |
| <a name="input_data_tiering"></a> [data\_tiering](#input\_data\_tiering) | Enables data tiering, not supported by all instance types: https://docs.aws.amazon.com/memorydb/latest/devguide/data-tiering.html. | `bool` | `false` | no |
| <a name="input_default_parameter_group"></a> [default\_parameter\_group](#input\_default\_parameter\_group) | Default parameter group to apply if none provided. Mapped to redis version. | `map(string)` | <pre>{<br>  "7.0": "default.memorydb-redis7",<br>  "7.1": "default.memorydb-redis7"<br>}</pre> | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Route53 custom name in the zone, optional. | `string` | `null` | no |
| <a name="input_iam_authenticated_roles"></a> [iam\_authenticated\_roles](#input\_iam\_authenticated\_roles) | A list of IAM role names allowed to authenticate on MemoryDB via IAM. | `list(string)` | `[]` | no |
| <a name="input_iam_authentication_enabled"></a> [iam\_authentication\_enabled](#input\_iam\_authentication\_enabled) | Enable IAM MemoryDB authentication. | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed.) | `string` | `"mon:06:00-mon:07:00"` | no |
| <a name="input_memorydb_name"></a> [memorydb\_name](#input\_memorydb\_name) | Name of the memorydb cluster. | `string` | n/a | yes |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes in the cluster. | `string` | n/a | yes |
| <a name="input_num_replicas_per_shard"></a> [num\_replicas\_per\_shard](#input\_num\_replicas\_per\_shard) | The number of replicas to apply to each shard. | `number` | `1` | no |
| <a name="input_num_shards"></a> [num\_shards](#input\_num\_shards) | The number of shards in the cluster. | `number` | `1` | no |
| <a name="input_open_cidr_blocks"></a> [open\_cidr\_blocks](#input\_open\_cidr\_blocks) | List of CIDR that can access the cluster. | `list(string)` | `[]` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Use 'default' to use the deafult parameter group. Use any other string to define a parameter group (in this case you should define the parameter group variables, if any). | `string` | `"default"` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Avalable values: 7.0, 7.1. | `string` | `"7.0"` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to create records in. | `string` | `null` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description of security group to create. | `string` | `"Managed by Terraform"` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of security group to create (optional). | `string` | `null` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"07:00-08:00"` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the subnet group to be used for the cache cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | A flag to enable in-transit encryption on the cluster. When set to false, the acl\_name must be open-access. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC where the security group belongs. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint_address"></a> [cluster\_endpoint\_address](#output\_cluster\_endpoint\_address) | DNS hostname of the cluster configuration endpoint |
| <a name="output_iam_full_access_policy_arn"></a> [iam\_full\_access\_policy\_arn](#output\_iam\_full\_access\_policy\_arn) | IAM policy ARN for IAM auth with full access to the database. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group id for MemoryDB Cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
