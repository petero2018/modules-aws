variable "memorydb_name" {
  description = "Name of the memorydb cluster."
  type        = string
}

variable "redis_version" {
  description = "Avalable values: 7.0, 7.1."
  type        = string

  default = "7.0"
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that automatic minor version upgrades are allowed. They will be performed during the maintenance window."
  type        = bool

  default = false
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes in the cluster."
  type        = string
}

variable "num_shards" {
  description = "The number of shards in the cluster."
  type        = number

  default = 1
}

variable "num_replicas_per_shard" {
  description = " The number of replicas to apply to each shard."
  type        = number

  default = 1

  validation {
    condition = (
      var.num_replicas_per_shard >= 1 &&
      var.num_replicas_per_shard <= 5
    )
    error_message = "The maximum value of the number of replicas to apply to each shard is 5."
  }
}

variable "parameter_group_name" {
  description = "Use 'default' to use the deafult parameter group. Use any other string to define a parameter group (in this case you should define the parameter group variables, if any)."
  type        = string

  default = "default"
}

variable "default_parameter_group" {
  description = "Default parameter group to apply if none provided. Mapped to redis version."
  type        = map(string)

  default = {
    "7.0" = "default.memorydb-redis7"
    "7.1" = "default.memorydb-redis7"
  }
}

variable "iam_authentication_enabled" {
  description = "Enable IAM MemoryDB authentication."
  type        = bool

  default = false
}

variable "iam_authenticated_roles" {
  description = "A list of IAM role names allowed to authenticate on MemoryDB via IAM."
  type        = list(string)

  default = []
}

variable "tls_enabled" {
  description = "A flag to enable in-transit encryption on the cluster. When set to false, the acl_name must be open-access."
  type        = bool

  default = false
}

variable "acl_name" {
  description = "The name of the Access Control List to associate with the cluster."
  type        = string

  default = "open-access"
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key."
  type        = string
}

variable "data_tiering" {
  description = "Enables data tiering, not supported by all instance types: https://docs.aws.amazon.com/memorydb/latest/devguide/data-tiering.html."
  type        = bool

  default = false
}

variable "security_group_name" {
  description = "Name of security group to create (optional)."
  type        = string

  default = null
}

variable "security_group_description" {
  type        = string
  description = "Description of security group to create."

  default = "Managed by Terraform"
}

variable "open_cidr_blocks" {
  description = "List of CIDR that can access the cluster."
  type        = list(string)

  default = []
}

variable "subnet_group_name" {
  description = "Name of the subnet group to be used for the cache cluster."
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC where the security group belongs."
  type        = string
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed.)"
  type        = string

  default = "mon:06:00-mon:07:00"
}

variable "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  type        = string

  default = "07:00-08:00"
}

variable "route53_zone_id" {
  description = "Route53 zone ID to create records in."
  type        = string

  default = null
}

variable "dns_name" {
  description = "Route53 custom name in the zone, optional."
  type        = string

  default = null
}

variable "tags" {
  description = "Tags to be applied to AWS resources."
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
