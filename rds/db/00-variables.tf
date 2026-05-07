variable "environment" {
  type        = string
  description = "Environment for the database to be deployed."
}

variable "name" {
  type        = string
  description = "Name for the database."
}

variable "identifier" {
  type        = string
  description = "Identifier for the database."
}

variable "team_tag" {
  type        = string
  description = "Team tag for the database and related resources."
}

variable "impact_tag" {
  type        = string
  description = "Impact tag for the database and related resources."
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags to set on the RDS instances."
  default     = {}
}

variable "route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 zone ID to create records in."
}

variable "dns_name" {
  type        = string
  default     = null
  description = "Route53 custom name in the zone, optional."
}

# Engine / instance
variable "engine_version" {
  type        = string
  description = "Database engine version. If allow_auto_minor_version_upgrade is enabled please specify just the prefix to avoid terraform drift."
}

variable "instance_class" {
  type        = string
  description = "Instance class for the database."
}

variable "engine" {
  type        = string
  description = "Engine type for the database."
}

variable "option_group" {
  type        = string
  description = "Option group name to configure the database."
}

variable "use_parameter_group_suffix" {
  type        = bool
  description = "Whether to set the engine version as a suffix for the parameter group name."
}

# Storage
variable "storage_allocated" {
  type        = number
  description = "Storage allocated for the database (in gigabytes)."
}

variable "storage_max_allocated" {
  type        = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance."
}

variable "storage_type" {
  type        = string
  description = "One of \"standard\" (magnetic), \"gp2\" (general purpose SSD), or \"io1\" (provisioned IOPS SSD)."
}

variable "storage_iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of \"io1\" or \"gp3\". Cannot be set on storage less than 400GB."
  default     = null
}

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
    error_message = "Only printable ASCII characters besides '/', '@', '\"', ' ' may be used(https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)."
  }
}

variable "credentials_encryption_key_id" {
  type        = string
  description = "Credentials encryption key id for the aws ssm parameters that will store the database credentials."
  default     = "alias/aws/ssm"
}

# Networking
variable "multi_az_enabled" {
  type        = bool
  description = "Specifies if the RDS instance is multi-AZ."
}

variable "vpc_id" {
  type        = string
  description = "VPC Id where the database will be running on."
}

variable "create_security_group" {
  type        = bool
  description = "Wheter a security group for the database should be created or not inside the module."
  default     = true
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
variable "prepare_deletion" {
  type        = bool
  default     = false
  description = "Prepare the instance for deletion by overriding some values."
}
variable "backup_enabled" {
  type        = bool
  description = "Whether backup is enabled for the database."
}

variable "blue_green_enabled" {
  type        = bool
  default     = false
  description = "Whether blue/green deployment is enabled for the database. To be effective backup_enabled variable has also be set to true."
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

variable "replica_configurations" {
  type = map(object({
    name                             = optional(string, "replica")
    instance_class                   = optional(string)
    iops                             = optional(number)
    performance_insights_enabled     = optional(bool, false)
    multi_az_enabled                 = optional(bool, false)
    enabling_cloudwatch_logs_exports = optional(list(string), [])
    use_default_parameters           = optional(bool, true)
    parameter_group_name             = optional(string)
    parameter_group_description      = optional(string)
    parameters = optional(map(object({
      value        = any # Can be string or number
      apply_method = optional(string, "immediate")
    })), {})
  }))
  description = "Specifies the configuration of the replica."
  default     = {}
}

variable "parameter_group_name" {
  type        = string
  description = "Sets the parameter group name for the parameter group."
  default     = null
}

variable "use_parameter_group_name_as_prefix" {
  type        = bool
  description = "Use passed DB parameter group name as prefix."
  default     = true
}

variable "parameter_group_description" {
  type        = string
  description = "Sets the parameter group description for the parameter group."
  default     = null
}

variable "use_default_parameters" {
  type        = bool
  description = "Sets whether default params should be used or not for the database. If true it will merge the defaults with the ones passed on `parameters`."
  default     = true
}

variable "parameters" {
  type = map(object({
    value        = any, # Can be string or number
    apply_method = optional(string, "immediate"),
  }))
  description = "Specifies custom configuration parameters for the database."
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Indicates that major version upgrades are allowed."
}

variable "allow_auto_minor_version_upgrade" {
  type        = bool
  default     = false
  description = "Indicates that automatic minor version upgrades are allowed. They will be performed during the maintenance window."
}

variable "restore_from_latest_snapshot" {
  type        = bool
  description = "Set to true to restore the database from the latest available snapshot."
}

variable "security_group_description" {
  type        = string
  description = "Description to set on the RDS security group."
  default     = "Managed by Terraform"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  default     = false
  description = "Enable IAM database authentication."
}

variable "iam_authenticated_roles" {
  type = list(string)

  default     = []
  description = "A list of IAM role names allowed to authenticate on RDS via IAM."
}

variable "iam_read_only_roles" {
  type = list(string)

  default     = []
  description = "A list of IAM role names allowed to authenticate on RDS via IAM for readonly access."
}

variable "default_parameters" {
  type = map(map(object({
    value        = any, # Can be string or number
    apply_method = optional(string, "immediate"),
  })))
  description = "Default parameters for each database type."
  default = {
    "mysql5.6" = {
      innodb_flush_log_at_trx_commit = { value = 1 }
      innodb_print_all_deadlocks     = { value = 0 }
      long_query_time                = { value = 1 }
      max_allowed_packet = {
        value        = 16777216
        apply_method = "pending-reboot"
      }
      max_heap_table_size = { value = 16777216 }
      slow_launch_time    = { value = 2 }
      slow_query_log      = { value = 1 }
      table_open_cache    = { value = 400 }
      tmp_table_size      = { value = 16777216 }
      wait_timeout        = { value = 28800 }
      innodb_file_format  = { value = "antelope" }
    },
    "mysql5.7" = {
      innodb_flush_log_at_trx_commit = { value = 1 }
      innodb_print_all_deadlocks     = { value = 0 }
      long_query_time                = { value = 1 }
      max_allowed_packet = {
        value        = 16777216
        apply_method = "pending-reboot"
      }
      max_heap_table_size = { value = 16777216 }
      slow_launch_time    = { value = 2 }
      slow_query_log      = { value = 1 }
      table_open_cache    = { value = 400 }
      tmp_table_size      = { value = 16777216 }
      wait_timeout        = { value = 28800 }
      innodb_file_format  = { value = "antelope" }
    },
    "mysql8.0" = {
      innodb_flush_log_at_trx_commit = { value = 1 }
      innodb_print_all_deadlocks     = { value = 0 }
      long_query_time                = { value = 1 }
      max_allowed_packet = {
        value        = 16777216
        apply_method = "pending-reboot"
      }
      max_heap_table_size = { value = 16777216 }
      slow_launch_time    = { value = 2 }
      slow_query_log      = { value = 1 }
      table_open_cache    = { value = 400 }
      tmp_table_size      = { value = 16777216 }
      wait_timeout        = { value = 28800 }
    },
    "postgres9.4" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = -1 }
      max_standby_streaming_delay = { value = -1 }
    },
    "postgres9.5" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = -1 }
      max_standby_streaming_delay = { value = -1 }
    },
    "postgres9.6" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = -1 }
      max_standby_streaming_delay = { value = -1 }
    },
    "postgres10" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = -1 }
      max_standby_streaming_delay = { value = -1 }
    },
    "postgres11" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
    },
    "postgres12" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
    },
    "postgres13" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
    },
    "postgres14" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
    },
    "postgres15" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
      "rds.force_ssl" = {
        apply_method = "immediate"
        value        = 0
      }
    }
    "postgres16" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
      "rds.force_ssl" = {
        apply_method = "immediate"
        value        = 0
      }
    }
    "postgres17" = {
      log_statement               = { value = "none" }
      log_min_duration_statement  = { value = 400 }
      max_standby_archive_delay   = { value = 90000 }
      max_standby_streaming_delay = { value = 90000 }
      "rds.force_ssl" = {
        apply_method = "immediate"
        value        = 0
      }
    }
  }
}

variable "ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance."
  default     = "rds-ca-rsa2048-g1"
}

variable "iam_auth_lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to set up the IAM auth user (replaces previous Jenkins hook)."
}

variable "fivetran" {
  type = object({
    enabled       = optional(bool, false)
    main_schema   = optional(string)
    main_database = optional(string)
  })
  default     = {}
  description = "Fivetran user creation options."
}

variable "monitoring_lambda" {
  type = object({
    enabled                = optional(bool, true)
    scheduler_iam_role_arn = string
    scheduler_group_name   = string
    monitoring_lambda_arn  = string
  })
  default     = null
  description = "Monitoring Lambda parameters."
}

variable "enable_proxy" {
  type        = bool
  default     = false
  description = "Whether to create an RDS Proxy instance."
}

variable "proxy_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN to be used by the RDS Proxy."
}

variable "proxy_max_connections_percentage" {
  type        = number
  default     = 90
  description = "Defines how many connections can be used by the RDS Proxy connection pool, in percentage of the database maximum connections."

  validation {
    condition     = var.proxy_max_connections_percentage >= 0 && var.proxy_max_connections_percentage <= 100
    error_message = "The proxy maximum connections percentage must be between 0 and 100 (inclusive)."
  }
}
