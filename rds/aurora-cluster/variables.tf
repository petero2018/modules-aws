variable "create_iam_groups" {
  type        = bool
  description = "Optionally create IAM groups for the database."
}

variable "environment" {
  type        = string
  description = "Environment for the database to be deployed."
}

variable "name" {
  type        = string
  description = "Name for the database."
}

variable "team_tag" {
  type        = string
  description = "Team tag for the database and related resources."
}

variable "impact_tag" {
  type        = string
  description = "Impact tag for the database and related resources."
}

# Cluster
variable "cluster_parameter_group" {
  type        = string
  description = "Parameter group to use for the aurora cluster."
}

# Engine
variable "engine_version" {
  type        = string
  description = "Database engine version."

  validation {
    condition     = contains(["5.7.mysql_aurora.2.10.2"], var.engine_version)
    error_message = "Unsupported engine version."
  }
}

variable "engine" {
  type        = string
  description = "Engine type for the database."
}

# Storage
variable "storage_encryption_arn" {
  type        = string
  description = "The ARN for the KMS encryption key."
}

variable "storage_encryption_enabled" {
  type        = bool
  description = "Whether the rds instance is encrypted at rest or not."
}

# Credentials
variable "username" {
  type        = string
  description = "Username for the master DB user."
}
variable "password" {
  type        = string
  description = "Password for the master DB user."

  #set default as empty string to generate one automatically inside the module
  default = ""
  validation {
    condition     = !can(regex("[\\s@\"\\/]", var.password))
    error_message = "Only printable ASCII characters besides '/', '@', '\"', ' ' may be used (https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)."
  }
}

variable "credentials_encryption_key_id" {
  type        = string
  description = "Credentials encryption key id for the aws ssm parameters that will store the database credentials."
  default     = "alias/aws/ssm"
}

# Networking
variable "vpc_id" {
  type        = string
  description = "VPC Id where the database will be running on."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of VPC security groups to associate."
}

variable "db_subnet_group_name" {
  type        = string
  description = "Name of DB subnet group."
}
variable "allowed_security_groups" {
  type        = list(any)
  description = "Security groups to allow ingress access to the database."
}
variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDRs to allow ingress access to the database."
}

# Logging
variable "enabling_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Set of log types to enable for exporting to CloudWatch logs."
}

# Other
variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\"."
}
variable "deletion_protection_enabled" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled."
}
variable "backup_enabled" {
  type        = bool
  description = "Whether backup is enabled for the database."
}
variable "backup_window" {
  type        = string
  description = "The backup window."
}
variable "backup_retention_days" {
  type        = number
  description = "The backup retention period."
}
variable "aws_backup_enabled" {
  type        = bool
  description = "Adds a new tag to enable AWS daily backups."
}

variable "enhanced_monitoring_enabled" {
  type        = bool
  description = "Whether enhanced monitoring is enabled or not."
}

variable "enhanced_monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance."
}

variable "enhanced_monitoring_role_arn" {
  type        = string
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Specifies whether Performance Insights are enabled. Defaults to false."
  default     = false
}

variable "replica_count" {
  type        = number
  description = "Specifies number of replicas to have on the cluster."
}

variable "replica_instance_class" {
  type        = string
  description = "Specifies the instance class for the replicas."
}

variable "restore_from_latest_snapshot" {
  type        = bool
  description = "Set to true to restore the database from the latest available snapshot."
}


variable "database_name" {
  type        = string
  description = "Sets the name for the database."
  default     = ""
}

variable "custom_identifier" {
  type        = bool
  description = "Whether to set a custom identifier database or not."
  default     = false
}

variable "custom_identifier_name" {
  type        = string
  description = "The custom identifier name to set on the database."
  default     = ""
}
