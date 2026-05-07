variable "name" {
  type        = string
  description = "Name that will be added to each Firehose stream."
}

variable "description" {
  type        = string
  description = "Description of the connector."
}

variable "connector_mode" {
  type        = string
  description = "Preset mode for the connector."
  default     = "s3"

  validation {
    condition     = contains(["s3", "custom"], var.connector_mode)
    error_message = "\"connector_mode\" must be 's3' or 'custom'."
  }
}

variable "output_bucket_name" {
  type        = string
  default     = null
  description = "Name of the S3 bucket to store the events."
}

variable "output_bucket_arn" {
  type        = string
  default     = null
  description = "ARN of the S3 bucket to store the events."
}

variable "kafka_topics" {
  type        = list(string)
  description = "List of Kafka topics to write into S3."
}

variable "custom_config" {
  type        = map(string)
  description = "Map of configuration parameters to add to the default configuration, string => string."
}

variable "custom_config_sensitive" {
  type        = map(string)
  description = "Map of sensitive configuration parameters to add to the default configuration, string => string."
  sensitive   = true
  default     = {}
}

variable "custom_worker_config" {
  type        = map(string)
  description = "Map of worker configuration parameters to add to the default configuration, string => string."
  default     = {}
}

variable "custom_worker_config_sensitive" {
  type        = map(string)
  description = "Map of sensitive worker configuration parameters to add to the default configuration, string => string."
  sensitive   = true
  default     = {}
}

variable "tags" {
  description = "Tags to identify resource ownership."
  type        = map(string)
  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "\"tags\" must contain at least those tags: \"team\", \"impact\", \"service\"."
  }
}

variable "worker_mcu_count" {
  type        = number
  default     = 1
  description = "MCU count per worker: 1 MCU = 1 vCPU + 4 GiB memory."
}

variable "min_worker_count" {
  type        = number
  default     = 1
  description = "Minimum worker count for autoscaling."
}

variable "max_worker_count" {
  type        = number
  default     = 2
  description = "Maximum worker count for autoscaling."
}

variable "scale_in_cpu_percentage" {
  type        = number
  default     = 40
  description = "Autoscaling: CPU percentage at which to scale in."
}

variable "scale_out_cpu_percentage" {
  type        = number
  default     = 80
  description = "Autoscaling: CPU percentage at which to scale out."
}

variable "max_tasks_count" {
  type        = number
  default     = 6
  description = "Maximum number of total Kafka Connect tasks."
}

variable "plugin_bucket_arn" {
  type        = string
  description = "ARN of the bucket used to store Kafka Connect plugins."
}

variable "plugin_path" {
  type        = string
  description = "S3 object path of the plugin to use in the connector."
}

variable "msk_bootstrap_brokers_tls" {
  type        = string
  description = "List of Kafka bootstrap brokers (TLS)."
}

variable "msk_security_group_ids" {
  type        = list(string)
  description = "List of Kafka security groups."
}

variable "msk_subnet_ids" {
  type        = list(string)
  description = "List of Kafka subnet IDs."
}

variable "cloudwatch_logs_retention_days" {
  type        = number
  default     = 7
  description = "Retention of the CloudWatch connector logs in days."
}
