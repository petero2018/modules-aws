# db

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_parameter_group.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_proxy.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_target.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) | resource |
| [aws_iam_policy.rds_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_iam_read_only_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy.rds_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_iam_read_only_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_invocation.iam_auth_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_route53_record.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_scheduler_schedule.monitoring_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_secretsmanager_secret.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_vpc_security_group_egress_rule.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [random_password.primary](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_db_snapshot.latest_snapshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_snapshot) | data source |
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_subnet_group) | data source |
| [aws_iam_policy_document.rds_iam_full_access_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rds_iam_read_only_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_minor_version_upgrade"></a> [allow\_auto\_minor\_version\_upgrade](#input\_allow\_auto\_minor\_version\_upgrade) | Indicates that automatic minor version upgrades are allowed. They will be performed during the maintenance window. | `bool` | `false` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. | `bool` | n/a | yes |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDRs to allow ingress access to the database. | `list(string)` | n/a | yes |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | Security groups to allow ingress access to the database. | `list(any)` | n/a | yes |
| <a name="input_aws_backup_enabled"></a> [aws\_backup\_enabled](#input\_aws\_backup\_enabled) | Adds a new tag to enable AWS daily backups. | `bool` | n/a | yes |
| <a name="input_backup_enabled"></a> [backup\_enabled](#input\_backup\_enabled) | Whether backup is enabled for the database. | `bool` | n/a | yes |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention period. | `number` | n/a | yes |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The backup window. | `string` | n/a | yes |
| <a name="input_blue_green_enabled"></a> [blue\_green\_enabled](#input\_blue\_green\_enabled) | Whether blue/green deployment is enabled for the database. To be effective backup\_enabled variable has also be set to true. | `bool` | `false` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa2048-g1"` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Wheter a security group for the database should be created or not inside the module. | `bool` | `true` | no |
| <a name="input_credentials_encryption_key_id"></a> [credentials\_encryption\_key\_id](#input\_credentials\_encryption\_key\_id) | Credentials encryption key id for the aws ssm parameters that will store the database credentials. | `string` | `"alias/aws/ssm"` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. | `string` | n/a | yes |
| <a name="input_default_parameters"></a> [default\_parameters](#input\_default\_parameters) | Default parameters for each database type. | <pre>map(map(object({<br>    value        = any, # Can be string or number<br>    apply_method = optional(string, "immediate"),<br>  })))</pre> | <pre>{<br>  "mysql5.6": {<br>    "innodb_file_format": {<br>      "value": "antelope"<br>    },<br>    "innodb_flush_log_at_trx_commit": {<br>      "value": 1<br>    },<br>    "innodb_print_all_deadlocks": {<br>      "value": 0<br>    },<br>    "long_query_time": {<br>      "value": 1<br>    },<br>    "max_allowed_packet": {<br>      "apply_method": "pending-reboot",<br>      "value": 16777216<br>    },<br>    "max_heap_table_size": {<br>      "value": 16777216<br>    },<br>    "slow_launch_time": {<br>      "value": 2<br>    },<br>    "slow_query_log": {<br>      "value": 1<br>    },<br>    "table_open_cache": {<br>      "value": 400<br>    },<br>    "tmp_table_size": {<br>      "value": 16777216<br>    },<br>    "wait_timeout": {<br>      "value": 28800<br>    }<br>  },<br>  "mysql5.7": {<br>    "innodb_file_format": {<br>      "value": "antelope"<br>    },<br>    "innodb_flush_log_at_trx_commit": {<br>      "value": 1<br>    },<br>    "innodb_print_all_deadlocks": {<br>      "value": 0<br>    },<br>    "long_query_time": {<br>      "value": 1<br>    },<br>    "max_allowed_packet": {<br>      "apply_method": "pending-reboot",<br>      "value": 16777216<br>    },<br>    "max_heap_table_size": {<br>      "value": 16777216<br>    },<br>    "slow_launch_time": {<br>      "value": 2<br>    },<br>    "slow_query_log": {<br>      "value": 1<br>    },<br>    "table_open_cache": {<br>      "value": 400<br>    },<br>    "tmp_table_size": {<br>      "value": 16777216<br>    },<br>    "wait_timeout": {<br>      "value": 28800<br>    }<br>  },<br>  "mysql8.0": {<br>    "innodb_flush_log_at_trx_commit": {<br>      "value": 1<br>    },<br>    "innodb_print_all_deadlocks": {<br>      "value": 0<br>    },<br>    "long_query_time": {<br>      "value": 1<br>    },<br>    "max_allowed_packet": {<br>      "apply_method": "pending-reboot",<br>      "value": 16777216<br>    },<br>    "max_heap_table_size": {<br>      "value": 16777216<br>    },<br>    "slow_launch_time": {<br>      "value": 2<br>    },<br>    "slow_query_log": {<br>      "value": 1<br>    },<br>    "table_open_cache": {<br>      "value": 400<br>    },<br>    "tmp_table_size": {<br>      "value": 16777216<br>    },<br>    "wait_timeout": {<br>      "value": 28800<br>    }<br>  },<br>  "postgres10": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": -1<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": -1<br>    }<br>  },<br>  "postgres11": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    }<br>  },<br>  "postgres12": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    }<br>  },<br>  "postgres13": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    }<br>  },<br>  "postgres14": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    }<br>  },<br>  "postgres15": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    },<br>    "rds.force_ssl": {<br>      "apply_method": "immediate",<br>      "value": 0<br>    }<br>  },<br>  "postgres16": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    },<br>    "rds.force_ssl": {<br>      "apply_method": "immediate",<br>      "value": 0<br>    }<br>  },<br>  "postgres17": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": 90000<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": 90000<br>    },<br>    "rds.force_ssl": {<br>      "apply_method": "immediate",<br>      "value": 0<br>    }<br>  },<br>  "postgres9.4": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": -1<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": -1<br>    }<br>  },<br>  "postgres9.5": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": -1<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": -1<br>    }<br>  },<br>  "postgres9.6": {<br>    "log_min_duration_statement": {<br>      "value": 400<br>    },<br>    "log_statement": {<br>      "value": "none"<br>    },<br>    "max_standby_archive_delay": {<br>      "value": -1<br>    },<br>    "max_standby_streaming_delay": {<br>      "value": -1<br>    }<br>  }<br>}</pre> | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | If the DB instance should have deletion protection enabled. | `bool` | n/a | yes |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Route53 custom name in the zone, optional. | `string` | `null` | no |
| <a name="input_enable_proxy"></a> [enable\_proxy](#input\_enable\_proxy) | Whether to create an RDS Proxy instance. | `bool` | `false` | no |
| <a name="input_enabling_cloudwatch_logs_exports"></a> [enabling\_cloudwatch\_logs\_exports](#input\_enabling\_cloudwatch\_logs\_exports) | Set of log types to enable for exporting to CloudWatch logs. | `list(string)` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine type for the database. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version. If allow\_auto\_minor\_version\_upgrade is enabled please specify just the prefix to avoid terraform drift. | `string` | n/a | yes |
| <a name="input_enhanced_monitoring_enabled"></a> [enhanced\_monitoring\_enabled](#input\_enhanced\_monitoring\_enabled) | Whether enhanced monitoring is enabled or not. | `bool` | n/a | yes |
| <a name="input_enhanced_monitoring_interval"></a> [enhanced\_monitoring\_interval](#input\_enhanced\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. | `number` | n/a | yes |
| <a name="input_enhanced_monitoring_role_arn"></a> [enhanced\_monitoring\_role\_arn](#input\_enhanced\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for the database to be deployed. | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to set on the RDS instances. | `map(string)` | `{}` | no |
| <a name="input_fivetran"></a> [fivetran](#input\_fivetran) | Fivetran user creation options. | <pre>object({<br>    enabled       = optional(bool, false)<br>    main_schema   = optional(string)<br>    main_database = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_iam_auth_lambda_function_name"></a> [iam\_auth\_lambda\_function\_name](#input\_iam\_auth\_lambda\_function\_name) | Name of the Lambda function to set up the IAM auth user (replaces previous Jenkins hook). | `string` | n/a | yes |
| <a name="input_iam_authenticated_roles"></a> [iam\_authenticated\_roles](#input\_iam\_authenticated\_roles) | A list of IAM role names allowed to authenticate on RDS via IAM. | `list(string)` | `[]` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Enable IAM database authentication. | `bool` | `false` | no |
| <a name="input_iam_read_only_roles"></a> [iam\_read\_only\_roles](#input\_iam\_read\_only\_roles) | A list of IAM role names allowed to authenticate on RDS via IAM for readonly access. | `list(string)` | `[]` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier for the database. | `string` | n/a | yes |
| <a name="input_impact_tag"></a> [impact\_tag](#input\_impact\_tag) | Impact tag for the database and related resources. | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class for the database. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: "ddd:hh24:mi-ddd:hh24:mi". Eg: "Mon:00:00-Mon:03:00". | `string` | n/a | yes |
| <a name="input_monitoring_lambda"></a> [monitoring\_lambda](#input\_monitoring\_lambda) | Monitoring Lambda parameters. | <pre>object({<br>    enabled                = optional(bool, true)<br>    scheduler_iam_role_arn = string<br>    scheduler_group_name   = string<br>    monitoring_lambda_arn  = string<br>  })</pre> | `null` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies if the RDS instance is multi-AZ. | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the database. | `string` | n/a | yes |
| <a name="input_option_group"></a> [option\_group](#input\_option\_group) | Option group name to configure the database. | `string` | n/a | yes |
| <a name="input_parameter_group_description"></a> [parameter\_group\_description](#input\_parameter\_group\_description) | Sets the parameter group description for the parameter group. | `string` | `null` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Sets the parameter group name for the parameter group. | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Specifies custom configuration parameters for the database. | <pre>map(object({<br>    value        = any, # Can be string or number<br>    apply_method = optional(string, "immediate"),<br>  }))</pre> | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. | `string` | `""` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_prepare_deletion"></a> [prepare\_deletion](#input\_prepare\_deletion) | Prepare the instance for deletion by overriding some values. | `bool` | `false` | no |
| <a name="input_proxy_max_connections_percentage"></a> [proxy\_max\_connections\_percentage](#input\_proxy\_max\_connections\_percentage) | Defines how many connections can be used by the RDS Proxy connection pool, in percentage of the database maximum connections. | `number` | `90` | no |
| <a name="input_proxy_role_arn"></a> [proxy\_role\_arn](#input\_proxy\_role\_arn) | IAM Role ARN to be used by the RDS Proxy. | `string` | `null` | no |
| <a name="input_replica_configurations"></a> [replica\_configurations](#input\_replica\_configurations) | Specifies the configuration of the replica. | <pre>map(object({<br>    name                             = optional(string, "replica")<br>    instance_class                   = optional(string)<br>    iops                             = optional(number)<br>    performance_insights_enabled     = optional(bool, false)<br>    multi_az_enabled                 = optional(bool, false)<br>    enabling_cloudwatch_logs_exports = optional(list(string), [])<br>    use_default_parameters           = optional(bool, true)<br>    parameter_group_name             = optional(string)<br>    parameter_group_description      = optional(string)<br>    parameters = optional(map(object({<br>      value        = any # Can be string or number<br>      apply_method = optional(string, "immediate")<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_restore_from_latest_snapshot"></a> [restore\_from\_latest\_snapshot](#input\_restore\_from\_latest\_snapshot) | Set to true to restore the database from the latest available snapshot. | `bool` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to create records in. | `string` | `null` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description to set on the RDS security group. | `string` | `"Managed by Terraform"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of VPC security groups to associate. | `list(string)` | n/a | yes |
| <a name="input_storage_allocated"></a> [storage\_allocated](#input\_storage\_allocated) | Storage allocated for the database (in gigabytes). | `number` | n/a | yes |
| <a name="input_storage_encryption_arn"></a> [storage\_encryption\_arn](#input\_storage\_encryption\_arn) | The ARN for the KMS encryption key. | `string` | n/a | yes |
| <a name="input_storage_encryption_enabled"></a> [storage\_encryption\_enabled](#input\_storage\_encryption\_enabled) | Whether the rds instance is encrypted at rest or not. | `bool` | n/a | yes |
| <a name="input_storage_iops"></a> [storage\_iops](#input\_storage\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of "io1" or "gp3". Cannot be set on storage less than 400GB. | `number` | `null` | no |
| <a name="input_storage_max_allocated"></a> [storage\_max\_allocated](#input\_storage\_max\_allocated) | The upper limit to which Amazon RDS can automatically scale the storage of the DB instance. | `number` | n/a | yes |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of "standard" (magnetic), "gp2" (general purpose SSD), or "io1" (provisioned IOPS SSD). | `string` | n/a | yes |
| <a name="input_team_tag"></a> [team\_tag](#input\_team\_tag) | Team tag for the database and related resources. | `string` | n/a | yes |
| <a name="input_use_default_parameters"></a> [use\_default\_parameters](#input\_use\_default\_parameters) | Sets whether default params should be used or not for the database. If true it will merge the defaults with the ones passed on `parameters`. | `bool` | `true` | no |
| <a name="input_use_parameter_group_name_as_prefix"></a> [use\_parameter\_group\_name\_as\_prefix](#input\_use\_parameter\_group\_name\_as\_prefix) | Use passed DB parameter group name as prefix. | `bool` | `true` | no |
| <a name="input_use_parameter_group_suffix"></a> [use\_parameter\_group\_suffix](#input\_use\_parameter\_group\_suffix) | Whether to set the engine version as a suffix for the parameter group name. | `bool` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC Id where the database will be running on. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | Address of the RDS instance. |
| <a name="output_iam_full_access_policy_arn"></a> [iam\_full\_access\_policy\_arn](#output\_iam\_full\_access\_policy\_arn) | IAM policy ARN for IAM auth with full access to the database. |
| <a name="output_iam_read_only_policy_arn"></a> [iam\_read\_only\_policy\_arn](#output\_iam\_read\_only\_policy\_arn) | IAM policy ARN for IAM auth with read only access to the database. |
| <a name="output_identifier"></a> [identifier](#output\_identifier) | Identifier of the RDS instance. |
| <a name="output_password"></a> [password](#output\_password) | Password for the RDS instance. |
| <a name="output_proxy_address"></a> [proxy\_address](#output\_proxy\_address) | Address of the RDS Proxy endpoint, if enabled. |
| <a name="output_replica_address"></a> [replica\_address](#output\_replica\_address) | Address of the replicas. |
| <a name="output_username"></a> [username](#output\_username) | Username for the RDS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
