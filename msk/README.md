# msk

This module deploys an Amazon Managed Streaming for Apache Kafka cluster.

## Usage

```hcl
module "kafka_main_datacollector" {
  source                       = "git@github.com:powise/terraform-modules//aws/msk?ref=msk-cluster-1.0.0"
  # Cluster Configuration
  full_name                    = "example-dev"
  kafka_version                = "3.3.1"
  broker_per_zone              = 1
  broker_instance_type         = "kafka.m5.large"
  # Deployment Configuration
  env                          = "dev"
  region                       = "us-east-1"
  # VPC Configuration
  vpc_id                       = "vpc-9e0ef9e4"
  # Security Groups
  enable_vpc_broker_access     = true
  enable_vpc_monitoring_access = true
  # Kafka Configuration
  configuration_properties     = {
    auto_create_topics         = false
    log_retention_hours        = 168 # 7 days
    default_replication_factor = 3
    num_partitions             = 3
  }
  # Route53
  custom_broker_endpoint_enabled = true
  custom_broker_endpoint_zone    = "dev.powise.com"
  custom_broker_endpoint         = "example.msk.us-east-1.dev.powise.com"
  # Communication Encryption
  encryption_in_cluster          = true
  client_broker                  = "TLS"
  # Authentication
  client_sasl_iam_enabled        = true
  # Broker Storage
  storage_gb_per_broker          = 50
  storage_autoscaling_enabled    = true
  storage_scaling_max_capacity   = 200
  storage_scaling_target_value   = 60
  # Monitoring
  monitoring_level               = "PER_TOPIC_PER_PARTITION"
  cloudwatch_logs_enabled        = true
  s3_logs_enabled                = true
  s3_logs_bucket                 = "powise-dev-logs"
  s3_logs_prefix                 = "msk"
  # Tags
  tags                           = {
    service = "kafka"
    team    = "data"
    impact  = "critical"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.55 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.55 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | ../kms | n/a |
| <a name="module_kms_scram"></a> [kms\_scram](#module\_kms\_scram) | ../kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.msk_external_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.msk_read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_msk_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_configuration.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_route53_record.broker_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.scram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.scram_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.msk_external_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_msk_broker_nodes.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/msk_broker_nodes) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources are created. | `string` | n/a | yes |
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | Instance type to use for the kafka broker. | `string` | `"kafka.m5.large"` | no |
| <a name="input_broker_per_zone"></a> [broker\_per\_zone](#input\_broker\_per\_zone) | Number of Kafka brokers per zone. | `number` | `1` | no |
| <a name="input_certificate_authority_arns"></a> [certificate\_authority\_arns](#input\_certificate\_authority\_arns) | List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication | `list(string)` | `[]` | no |
| <a name="input_client_allow_unauthenticated"></a> [client\_allow\_unauthenticated](#input\_client\_allow\_unauthenticated) | Enables unauthenticated access. | `bool` | `false` | no |
| <a name="input_client_broker"></a> [client\_broker](#input\_client\_broker) | Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT` | `string` | `"TLS"` | no |
| <a name="input_client_sasl_iam_enabled"></a> [client\_sasl\_iam\_enabled](#input\_client\_sasl\_iam\_enabled) | Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_*_enabled`). | `bool` | `false` | no |
| <a name="input_client_sasl_scram_enabled"></a> [client\_sasl\_scram\_enabled](#input\_client\_sasl\_scram\_enabled) | Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`). | `bool` | `false` | no |
| <a name="input_client_sasl_scram_secret_association_arns"></a> [client\_sasl\_scram\_secret\_association\_arns](#input\_client\_sasl\_scram\_secret\_association\_arns) | List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to `true` at the same time as `client_tls_auth_enabled`). | `list(string)` | `[]` | no |
| <a name="input_client_tls_auth_enabled"></a> [client\_tls\_auth\_enabled](#input\_client\_tls\_auth\_enabled) | Set `true` to enable the Client TLS Authentication | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_log_group"></a> [cloudwatch\_logs\_log\_group](#input\_cloudwatch\_logs\_log\_group) | Name of the Cloudwatch Log Group to deliver logs to | `string` | `null` | no |
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | Kafka CloudWatch logs retention (days). | `number` | `30` | no |
| <a name="input_configuration_arn"></a> [configuration\_arn](#input\_configuration\_arn) | ARN of the MSK Configuration to use in the cluster. | `string` | `null` | no |
| <a name="input_configuration_name"></a> [configuration\_name](#input\_configuration\_name) | Custom MSK configuration name (optional). | `string` | `null` | no |
| <a name="input_configuration_properties"></a> [configuration\_properties](#input\_configuration\_properties) | Contents of the server.properties file. | <pre>object({<br>    # https://kafka.apache.org/documentation/#brokerconfigs_auto.create.topics.enable<br>    # Enable auto creation of topic on the server<br>    auto_create_topics = optional(bool, false)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_log.retention.hours<br>    # The number of hours to keep a log file before deleting it (in hours), tertiary to log.retention.ms property<br>    log_retention_hours = optional(number, 168)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_default.replication.factor<br>    # The default replication factors for automatically created topics<br>    default_replication_factor = optional(number, 3)<br>    # https://kafka.apache.org/documentation/#topicconfigs_min.insync.replicas<br>    # Minimum in sync replicas to consider a message stored in kafka<br>    min_insync_replicas = optional(number, 2) # Should be `RF - 1` in general<br>    # https://kafka.apache.org/documentation/#brokerconfigs_num.partitions<br>    # The default number of log partitions per topic<br>    num_partitions = optional(number, 3)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_num.io.threads<br>    # The number of threads that the server uses for processing requests, which may include disk I/O<br>    num_io_threads = optional(number, 8)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_num.network.threads<br>    # The number of threads that the server uses for receiving requests from the network and sending responses to the network<br>    num_network_threads = optional(number, 5)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_num.replica.fetchers<br>    # Number of fetcher threads used to replicate records from each source broker.<br>    num_replica_fetchers = optional(number, 2)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_socket.request.max.bytes<br>    # The maximum number of bytes in a socket request<br>    socket_request_max_bytes = optional(number, 104857600)<br>    # https://kafka.apache.org/documentation/#brokerconfigs_unclean.leader.election.enable<br>    # Whether to enable unclean leader elections (AWS MSK sets this to true by default for EBS storage)<br>    unclean_leader_election_enable = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_configuration_properties_extra"></a> [configuration\_properties\_extra](#input\_configuration\_properties\_extra) | Extra contents of the server.properties file. All supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html) | `map(string)` | `{}` | no |
| <a name="input_configuration_revision"></a> [configuration\_revision](#input\_configuration\_revision) | Revision of the MSK Configuration to use in the cluster. | `number` | `null` | no |
| <a name="input_custom_broker_endpoint"></a> [custom\_broker\_endpoint](#input\_custom\_broker\_endpoint) | Fully qualified domain for your custom endpoint. | `string` | `null` | no |
| <a name="input_custom_broker_endpoint_enabled"></a> [custom\_broker\_endpoint\_enabled](#input\_custom\_broker\_endpoint\_enabled) | Enables Custom Endpoint URL | `bool` | `false` | no |
| <a name="input_custom_broker_endpoint_zone"></a> [custom\_broker\_endpoint\_zone](#input\_custom\_broker\_endpoint\_zone) | Zone where the custom endpoint will be created. | `string` | `null` | no |
| <a name="input_enable_broker_access_from_cidrs"></a> [enable\_broker\_access\_from\_cidrs](#input\_enable\_broker\_access\_from\_cidrs) | List of CIDRs allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_enable_broker_access_from_sg"></a> [enable\_broker\_access\_from\_sg](#input\_enable\_broker\_access\_from\_sg) | List of Security Groups allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_enable_monitoring_access_from_cidrs"></a> [enable\_monitoring\_access\_from\_cidrs](#input\_enable\_monitoring\_access\_from\_cidrs) | List of CIDRs allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_enable_monitoring_access_from_sg"></a> [enable\_monitoring\_access\_from\_sg](#input\_enable\_monitoring\_access\_from\_sg) | List of Security Groups allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_enable_zookeeper_access_from_cidrs"></a> [enable\_zookeeper\_access\_from\_cidrs](#input\_enable\_zookeeper\_access\_from\_cidrs) | List of CIDRs allowed to full access from. | `list(string)` | `[]` | no |
| <a name="input_enable_zookeeper_access_from_sg"></a> [enable\_zookeeper\_access\_from\_sg](#input\_enable\_zookeeper\_access\_from\_sg) | List of Security Groups allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_encryption_in_cluster"></a> [encryption\_in\_cluster](#input\_encryption\_in\_cluster) | Whether data communication among broker nodes is encrypted | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to deploy MSK cluster to. | `string` | n/a | yes |
| <a name="input_external_reader_roles"></a> [external\_reader\_roles](#input\_external\_reader\_roles) | Map of `IAM role name => AWS Account ID`, creates matching IAM roles with read-only access to the cluster. | `map(string)` | `{}` | no |
| <a name="input_full_name"></a> [full\_name](#input\_full\_name) | Full Name of the MSK cluster. | `string` | `null` | no |
| <a name="input_jmx_exporter_enabled"></a> [jmx\_exporter\_enabled](#input\_jmx\_exporter\_enabled) | Set `true` to enable the JMX Exporter | `bool` | `true` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Kafka version to deploy. | `string` | `"3.3.1"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting all msk data. If not defined it will create one. | `string` | `null` | no |
| <a name="input_monitoring_level"></a> [monitoring\_level](#input\_monitoring\_level) | Specify the desired enhanced MSK CloudWatch monitoring level. [More info](https://docs.aws.amazon.com/msk/latest/developerguide/metrics-details.html) | `string` | `"PER_TOPIC_PER_PARTITION"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the MSK cluster. | `string` | `null` | no |
| <a name="input_node_exporter_enabled"></a> [node\_exporter\_enabled](#input\_node\_exporter\_enabled) | Set `true` to enable the Node Exporter | `bool` | `true` | no |
| <a name="input_scram_users"></a> [scram\_users](#input\_scram\_users) | List of usernames to create for SCRAM client authentication. | `list(string)` | `[]` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Custom security group description (optional). | `string` | `null` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of the Kafka security group (optional). | `string` | `null` | no |
| <a name="input_storage_autoscaling_disable_scale_in"></a> [storage\_autoscaling\_disable\_scale\_in](#input\_storage\_autoscaling\_disable\_scale\_in) | If the value is true, scale in is disabled and the target tracking policy won't remove capacity from the scalable resource. | `bool` | `false` | no |
| <a name="input_storage_autoscaling_enabled"></a> [storage\_autoscaling\_enabled](#input\_storage\_autoscaling\_enabled) | To automatically expand your cluster's storage in response to increased usage, you can enable this. [More info](https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpand.html) | `bool` | `true` | no |
| <a name="input_storage_gb_per_broker"></a> [storage\_gb\_per\_broker](#input\_storage\_gb\_per\_broker) | The size in GiB of the EBS volume for the data drive on each broker node. | `number` | n/a | yes |
| <a name="input_storage_mode"></a> [storage\_mode](#input\_storage\_mode) | Sets the Kafka storage mode. | `string` | `"LOCAL"` | no |
| <a name="input_storage_scaling_max_capacity"></a> [storage\_scaling\_max\_capacity](#input\_storage\_scaling\_max\_capacity) | The maximum capacity of the scalable target. | `number` | `1024` | no |
| <a name="input_storage_scaling_target_value"></a> [storage\_scaling\_target\_value](#input\_storage\_scaling\_target\_value) | The target value for the metric. | `number` | `60` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the Kafka brokers to be created in. Will use subnet tags if not defined. | `list(string)` | `null` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to lookup subnets for the Kafka brokers to be created in. vpc\_id must be defined. | `map(string)` | <pre>{<br>  "tier": "private"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the cluster will be created (e.g. `vpc-aceb2723`). Will use subnet\_ids if not defined. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_iam"></a> [bootstrap\_brokers\_iam](#output\_bootstrap\_brokers\_iam) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/IAM to the kafka cluster. |
| <a name="output_bootstrap_brokers_scram"></a> [bootstrap\_brokers\_scram](#output\_bootstrap\_brokers\_scram) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/SCRAM to the kafka cluster. |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the MSK cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | MSK Cluster name |
| <a name="output_config_arn"></a> [config\_arn](#output\_config\_arn) | Amazon Resource Name (ARN) of the configuration |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Comma separated list of one or more MSK Cluster Broker DNS hostname |
| <a name="output_latest_revision"></a> [latest\_revision](#output\_latest\_revision) | Latest revision of the configuration |
| <a name="output_scram_users_credentials"></a> [scram\_users\_credentials](#output\_scram\_users\_credentials) | Credentials for created SCRAM users: { username => password }. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security groups used by Kafka. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnet IDs used by Kafka. |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
