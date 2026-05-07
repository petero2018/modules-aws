################################################################################
# Cluster Configuration
################################################################################

variable "name" {
  type        = string
  default     = null
  description = "Name of the MSK cluster."
}

variable "full_name" {
  type        = string
  default     = null
  description = "Full Name of the MSK cluster."
}

variable "kafka_version" {
  type        = string
  default     = "3.3.1"
  description = "Kafka version to deploy."
}

variable "broker_per_zone" {
  type        = number
  default     = 1
  description = "Number of Kafka brokers per zone."
  validation {
    condition     = var.broker_per_zone > 0
    error_message = "The broker_per_zone value must be at atleast 1."
  }
}

variable "broker_instance_type" {
  type        = string
  default     = "kafka.m5.large"
  description = "Instance type to use for the kafka broker."
}

################################################################################
# Deployment Configuration
################################################################################

variable "env" {
  type        = string
  description = "Environment to deploy MSK cluster to."
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources are created."
}

################################################################################
# VPC Configuration
################################################################################

variable "vpc_id" {
  type = string

  default     = null
  description = "VPC ID where the cluster will be created (e.g. `vpc-aceb2723`). Will use subnet_ids if not defined."
}

variable "subnet_ids" {
  type = list(string)

  default     = null
  description = "List of VPC Subnet IDs for the Kafka brokers to be created in. Will use subnet tags if not defined."
}

variable "subnet_tags" {
  type = map(string)

  default     = { tier = "private" }
  description = "Tags to lookup subnets for the Kafka brokers to be created in. vpc_id must be defined."
}

################################################################################
# Security Groups
################################################################################

variable "security_group_name" {
  type = string

  default     = null
  description = "Name of the Kafka security group (optional)."
}

variable "security_group_description" {
  type = string

  default     = null
  description = "Custom security group description (optional)."
}

variable "enable_broker_access_from_cidrs" {
  type = list(string)

  default     = []
  description = "List of CIDRs allowed to access from."
}

variable "enable_broker_access_from_sg" {
  type = list(string)

  default     = []
  description = "List of Security Groups allowed to access from."
}

variable "enable_monitoring_access_from_cidrs" {
  type = list(string)

  default     = []
  description = "List of CIDRs allowed to access from."
}

variable "enable_monitoring_access_from_sg" {
  type = list(string)

  default     = []
  description = "List of Security Groups allowed to access from."
}

variable "enable_zookeeper_access_from_cidrs" {
  type = list(string)

  default     = []
  description = "List of CIDRs allowed to full access from."
}

variable "enable_zookeeper_access_from_sg" {
  type = list(string)

  default     = []
  description = "List of Security Groups allowed to access from."
}

################################################################################
# Kafka Configuration
################################################################################

variable "configuration_arn" {
  type        = string
  default     = null
  description = "ARN of the MSK Configuration to use in the cluster."
}

variable "configuration_name" {
  type        = string
  default     = null
  description = "Custom MSK configuration name (optional)."
}

variable "configuration_revision" {
  type        = number
  default     = null
  description = "Revision of the MSK Configuration to use in the cluster."
}

variable "configuration_properties" {
  type = object({
    # https://kafka.apache.org/documentation/#brokerconfigs_auto.create.topics.enable
    # Enable auto creation of topic on the server
    auto_create_topics = optional(bool, false)
    # https://kafka.apache.org/documentation/#brokerconfigs_log.retention.hours
    # The number of hours to keep a log file before deleting it (in hours), tertiary to log.retention.ms property
    log_retention_hours = optional(number, 168)
    # https://kafka.apache.org/documentation/#brokerconfigs_default.replication.factor
    # The default replication factors for automatically created topics
    default_replication_factor = optional(number, 3)
    # https://kafka.apache.org/documentation/#topicconfigs_min.insync.replicas
    # Minimum in sync replicas to consider a message stored in kafka
    min_insync_replicas = optional(number, 2) # Should be `RF - 1` in general
    # https://kafka.apache.org/documentation/#brokerconfigs_num.partitions
    # The default number of log partitions per topic
    num_partitions = optional(number, 3)
    # https://kafka.apache.org/documentation/#brokerconfigs_num.io.threads
    # The number of threads that the server uses for processing requests, which may include disk I/O
    num_io_threads = optional(number, 8)
    # https://kafka.apache.org/documentation/#brokerconfigs_num.network.threads
    # The number of threads that the server uses for receiving requests from the network and sending responses to the network
    num_network_threads = optional(number, 5)
    # https://kafka.apache.org/documentation/#brokerconfigs_num.replica.fetchers
    # Number of fetcher threads used to replicate records from each source broker.
    num_replica_fetchers = optional(number, 2)
    # https://kafka.apache.org/documentation/#brokerconfigs_socket.request.max.bytes
    # The maximum number of bytes in a socket request
    socket_request_max_bytes = optional(number, 104857600)
    # https://kafka.apache.org/documentation/#brokerconfigs_unclean.leader.election.enable
    # Whether to enable unclean leader elections (AWS MSK sets this to true by default for EBS storage)
    unclean_leader_election_enable = optional(bool, true)
  })
  default     = {}
  description = "Contents of the server.properties file."
}

variable "configuration_properties_extra" {
  type        = map(string)
  default     = {}
  description = "Extra contents of the server.properties file. All supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
}

################################################################################
# Route53
################################################################################

variable "custom_broker_endpoint_enabled" {
  type = bool

  default     = false
  description = "Enables Custom Endpoint URL"
}

variable "custom_broker_endpoint_zone" {
  type = string

  default     = null
  description = "Zone where the custom endpoint will be created."
}

variable "custom_broker_endpoint" {
  type = string

  default     = null
  description = "Fully qualified domain for your custom endpoint."
}

################################################################################
# Communication Encryption
################################################################################

variable "encryption_in_cluster" {
  type        = bool
  default     = true
  description = "Whether data communication among broker nodes is encrypted"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting all msk data. If not defined it will create one."
}

variable "client_broker" {
  type        = string
  default     = "TLS"
  description = "Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`"

  validation {
    condition     = contains(["TLS", "TLS_PLAINTEXT", "PLAINTEXT"], var.client_broker)
    error_message = "Invalid client encryption! Please provide a valid one 'TLS', 'TLS_PLAINTEXT' or 'PLAINTEXT'."
  }
}

################################################################################
# Authentication
################################################################################

variable "certificate_authority_arns" {
  type        = list(string)
  default     = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}

variable "client_allow_unauthenticated" {
  type        = bool
  default     = false
  description = "Enables unauthenticated access."
}

variable "client_sasl_scram_enabled" {
  type        = bool
  default     = false
  description = "Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "client_sasl_iam_enabled" {
  type        = bool
  default     = false
  description = "Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_*_enabled`)."
}

variable "client_tls_auth_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the Client TLS Authentication"
}

variable "scram_users" {
  type        = list(string)
  default     = []
  description = "List of usernames to create for SCRAM client authentication."
}

################################################################################
# Broker Storage
################################################################################

variable "storage_gb_per_broker" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node."
}

variable "storage_autoscaling_enabled" {
  type        = bool
  default     = true
  description = "To automatically expand your cluster's storage in response to increased usage, you can enable this. [More info](https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpand.html)"
}

variable "storage_scaling_max_capacity" {
  type        = number
  default     = 1024
  description = "The maximum capacity of the scalable target."
}
variable "storage_scaling_target_value" {
  type        = number
  default     = 60
  description = "The target value for the metric."
}

variable "storage_autoscaling_disable_scale_in" {
  type        = bool
  default     = false
  description = "If the value is true, scale in is disabled and the target tracking policy won't remove capacity from the scalable resource."
}

variable "storage_mode" {
  type        = string
  default     = "LOCAL"
  description = "Sets the Kafka storage mode."
}

################################################################################
# Monitoring
################################################################################

variable "monitoring_level" {
  type        = string
  default     = "PER_TOPIC_PER_PARTITION"
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. [More info](https://docs.aws.amazon.com/msk/latest/developerguide/metrics-details.html)"

  validation {
    condition = contains([
      "DEFAULT",
      "PER_BROKER",
      "PER_TOPIC_PER_BROKER",
      "PER_TOPIC_PER_PARTITION"
    ], var.monitoring_level)
    error_message = "Invalid monitoring level! Please provide a valid one 'DEFAULT', 'PER_BROKER', 'PER_TOPIC_PER_BROKER' or 'PER_TOPIC_PER_PARTITION'."
  }
}

variable "jmx_exporter_enabled" {
  type        = bool
  default     = true
  description = "Set `true` to enable the JMX Exporter"
}

variable "node_exporter_enabled" {
  type        = bool
  default     = true
  description = "Set `true` to enable the Node Exporter"
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "cloudwatch_logs_log_group" {
  type        = string
  default     = null
  description = "Name of the Cloudwatch Log Group to deliver logs to"
}

variable "cloudwatch_logs_retention_days" {
  type        = number
  default     = 30
  description = "Kafka CloudWatch logs retention (days)."
}

################################################################################
# IAM roles
################################################################################

variable "external_reader_roles" {
  type        = map(string)
  default     = {}
  description = "Map of `IAM role name => AWS Account ID`, creates matching IAM roles with read-only access to the cluster."
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "Tags to be applied to all AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
