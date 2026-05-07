# aurora-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |
| <a name="provider_aws.identity"></a> [aws.identity](#provider\_aws.identity) | >= 3.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.rds_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.rds_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_rds_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.primary](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_db_cluster_snapshot.latest_snapshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_cluster_snapshot) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDRs to allow ingress access to the database. | `list(string)` | n/a | yes |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | Security groups to allow ingress access to the database. | `list(any)` | n/a | yes |
| <a name="input_aws_backup_enabled"></a> [aws\_backup\_enabled](#input\_aws\_backup\_enabled) | Adds a new tag to enable AWS daily backups. | `bool` | n/a | yes |
| <a name="input_backup_enabled"></a> [backup\_enabled](#input\_backup\_enabled) | Whether backup is enabled for the database. | `bool` | n/a | yes |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention period. | `number` | n/a | yes |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The backup window. | `string` | n/a | yes |
| <a name="input_cluster_parameter_group"></a> [cluster\_parameter\_group](#input\_cluster\_parameter\_group) | Parameter group to use for the aurora cluster. | `string` | n/a | yes |
| <a name="input_create_iam_groups"></a> [create\_iam\_groups](#input\_create\_iam\_groups) | Optionally create IAM groups for the database. | `bool` | n/a | yes |
| <a name="input_credentials_encryption_key_id"></a> [credentials\_encryption\_key\_id](#input\_credentials\_encryption\_key\_id) | Credentials encryption key id for the aws ssm parameters that will store the database credentials. | `string` | `"alias/aws/ssm"` | no |
| <a name="input_custom_identifier"></a> [custom\_identifier](#input\_custom\_identifier) | Whether to set a custom identifier database or not. | `bool` | `false` | no |
| <a name="input_custom_identifier_name"></a> [custom\_identifier\_name](#input\_custom\_identifier\_name) | The custom identifier name to set on the database. | `string` | `""` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Sets the name for the database. | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. | `string` | n/a | yes |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | If the DB instance should have deletion protection enabled. | `bool` | n/a | yes |
| <a name="input_enabling_cloudwatch_logs_exports"></a> [enabling\_cloudwatch\_logs\_exports](#input\_enabling\_cloudwatch\_logs\_exports) | Set of log types to enable for exporting to CloudWatch logs. | `list(string)` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine type for the database. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version. | `string` | n/a | yes |
| <a name="input_enhanced_monitoring_enabled"></a> [enhanced\_monitoring\_enabled](#input\_enhanced\_monitoring\_enabled) | Whether enhanced monitoring is enabled or not. | `bool` | n/a | yes |
| <a name="input_enhanced_monitoring_interval"></a> [enhanced\_monitoring\_interval](#input\_enhanced\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. | `number` | n/a | yes |
| <a name="input_enhanced_monitoring_role_arn"></a> [enhanced\_monitoring\_role\_arn](#input\_enhanced\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for the database to be deployed. | `string` | n/a | yes |
| <a name="input_impact_tag"></a> [impact\_tag](#input\_impact\_tag) | Impact tag for the database and related resources. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: "ddd:hh24:mi-ddd:hh24:mi". Eg: "Mon:00:00-Mon:03:00". | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the database. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. | `string` | `""` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Specifies number of replicas to have on the cluster. | `number` | n/a | yes |
| <a name="input_replica_instance_class"></a> [replica\_instance\_class](#input\_replica\_instance\_class) | Specifies the instance class for the replicas. | `string` | n/a | yes |
| <a name="input_restore_from_latest_snapshot"></a> [restore\_from\_latest\_snapshot](#input\_restore\_from\_latest\_snapshot) | Set to true to restore the database from the latest available snapshot. | `bool` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of VPC security groups to associate. | `list(string)` | n/a | yes |
| <a name="input_storage_encryption_arn"></a> [storage\_encryption\_arn](#input\_storage\_encryption\_arn) | The ARN for the KMS encryption key. | `string` | n/a | yes |
| <a name="input_storage_encryption_enabled"></a> [storage\_encryption\_enabled](#input\_storage\_encryption\_enabled) | Whether the rds instance is encrypted at rest or not. | `bool` | n/a | yes |
| <a name="input_team_tag"></a> [team\_tag](#input\_team\_tag) | Team tag for the database and related resources. | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC Id where the database will be running on. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
