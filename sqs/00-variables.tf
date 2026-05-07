variable "name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "A unique name beginning with the specified prefix."
  type        = string
  default     = null
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "\"visibility_timeout_seconds\" must be an integer between 0 and 43200 (12 hours)."
  }
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600 # 4 days

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "\"message_retention_seconds\" must be an integer between 60 (1 minute) and 1209600 (14 days)."
  }
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144 # 256 KB

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "\"max_message_size\" must be an integer between 1024 (1 KB) and 262144 (256 KB)."
  }
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "\"delay_seconds\" must be an integer between 0 and 900 (15 minutes)."
  }
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "\"receive_wait_time_seconds\" must be an integer between 0 and 20."
  }
}

variable "access_policy" {
  description = "The JSON policy for the SQS queue"
  type        = string
  default     = null
}

variable "deny_insecure_transport" {
  type        = bool
  description = "Whether to enable access policy to deny insecure transport in access policy."
  default     = true
}

variable "redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  type = object({
    deadLetterTargetArn = string
    maxReceiveCount     = number
  })
  validation {
    condition     = var.redrive_policy == null ? true : var.redrive_policy.maxReceiveCount >= 1 && var.redrive_policy.maxReceiveCount <= 1000
    error_message = "\"maxReceiveCount\" must be an integer between 1 and 1000."
  }
  default = null
}

variable "redrive_allow_policy" {
  description = "The JSON policy to set up the Dead Letter Queue redrive permission."
  type = object({
    redrivePermission = string
    sourceQueueArns   = optional(list(string))
  })
  validation {
    condition     = var.redrive_allow_policy == null ? true : contains(["allowAll", "byQueue", "denyAll"], var.redrive_allow_policy.redrivePermission)
    error_message = "\"redrivePermission\" valid values are 'allowAll', 'byQueue', 'denyAll'."
  }
  validation {
    condition     = var.redrive_allow_policy == null ? true : (var.redrive_allow_policy.redrivePermission == "byQueue" ? var.redrive_allow_policy.sourceQueueArns != null && length(var.redrive_allow_policy.sourceQueueArns) <= 10 : true)
    error_message = "When redrivePermission is set to \"byQueue\", sourceQueueArns must be a list of no more than 10 valid queue ARNs."
  }
  validation {
    condition     = var.redrive_allow_policy == null ? true : (contains(["allowAll", "denyAll"], var.redrive_allow_policy.redrivePermission) ? var.redrive_allow_policy.sourceQueueArns == null : true)
    error_message = "When redrivePermission is set to \"allowAll\" or \"denyAll\", sourceQueueArns cannot be set."
  }
  default = null
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "encryption_at_rest" {
  description = "Encryption-at-rest settings for the queue"
  type = object({
    sqs_managed_sse_enabled = optional(bool)
    kms_sse = optional(object({
      kms_master_key_id                 = string
      kms_data_key_reuse_period_seconds = number
    }))
  })
  default = {
    sqs_managed_sse_enabled = true
  }

  validation {
    condition     = (var.encryption_at_rest.sqs_managed_sse_enabled == null || var.encryption_at_rest.sqs_managed_sse_enabled == false) ? var.encryption_at_rest.kms_sse != null : true
    error_message = "Invalid encryption-at-rest settings. Either SQS-managed or KMS encryption is required."
  }
  validation {
    condition     = var.encryption_at_rest.kms_sse == null ? true : var.encryption_at_rest.kms_sse.kms_data_key_reuse_period_seconds >= 60 && var.encryption_at_rest.kms_sse.kms_data_key_reuse_period_seconds <= 86400
    error_message = "\"kms_data_key_reuse_period_seconds\" must be an integer between 60 (1 minute) and 86400 (24 hours)."
  }
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level"
  type        = string
  default     = null

  validation {
    condition     = var.deduplication_scope == null ? true : (var.deduplication_scope == "messageGroup" || var.deduplication_scope == "queue")
    error_message = "\"deduplication_scope\" valid values are 'messageGroup' or 'queue'."
  }
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group"
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_limit == null ? true : (var.fifo_throughput_limit == "perMessageGroupId" || var.fifo_throughput_limit == "perQueue")
    error_message = "\"fifo_throughput_limit\" valid values are 'perMessageGroupId' or 'perQueue'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources."
  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
