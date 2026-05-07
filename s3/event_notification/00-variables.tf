variable "sns_notifications" {
  type = map(object({
    topic_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  description = "Options for S3 event notifications (SNS)"
  default     = null
}

variable "sqs_notifications" {
  type = map(object({
    queue_arn     = string
    events        = list(string)
    queue_url     = optional(string) # Queue URL is needed only when creating policy
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  description = "Options for S3 event notifications (SQS)"
  default     = null
}

variable "lambda_notifications" {
  type = map(object({
    function_name       = string
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = optional(string)
    filter_suffix       = optional(string)
    qualifier           = optional(string)
    source_account      = optional(string)
  }))
  description = "Options for S3 event notifications (Lambda)"
  default     = null
}

variable "eventbridge" {
  description = "Whether to enable Amazon EventBridge notifications"
  type        = bool
  default     = null
}

variable "create_sns_policy" {
  description = "Whether to create a policy for SNS permissions or not?"
  type        = bool
  default     = false
}

variable "create_sqs_policy" {
  description = "Whether to create a policy for SQS permissions or not?"
  type        = bool
  default     = false
}

variable "create_lambda_permission" {
  description = "Whether to create a lambda permission for S3 or not?"
  type        = bool
  default     = false
}

variable "bucket" {
  description = "Name of S3 bucket to use"
  type        = string
  default     = ""
}

variable "bucket_arn" {
  description = "ARN of S3 bucket to use in policies"
  type        = string
  default     = null
}
