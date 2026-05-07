variable "bucket_id" {
  type        = string
  description = "S3 bucket ID to replicate."
}

variable "bucket_arn" {
  type        = string
  description = "S3 bucket ARN to replicate."
}

variable "replication_config" {
  type = map(object({
    target_bucket_arn            = string
    target_bucket_aws_account_id = string
    priority                     = optional(string, 0)
    source_kms_key_id            = optional(string, null)
    target_kms_key_id            = optional(string, null)
    target_storage_class         = optional(string, "STANDARD")
    filter = optional(object({
      prefix = string
      tag = optional(object({
        key   = string
        value = string
      }), null)
    }), null)
  }))
  description = "Map of replication configurations, in priority order."
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
