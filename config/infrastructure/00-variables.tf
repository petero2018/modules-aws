variable "account_name" {
  type        = string
  description = "The name of the account for which AWS Config will be configured"
}

variable "account_suffix" {
  type        = string
  description = "The value of this will be suffixed to the account name when constructing the final bucket name"
  default     = ""
}

variable "bucket_object_lock_config" {
  type = object({
    expected_bucket_owner = optional(string)
    token                 = optional(string)
    default_retention = object({
      mode  = string
      days  = optional(number)
      years = optional(number)
    })
  })
  default     = null
  description = "Object lock configuration for when the bucket requires it"
}

variable "create_sns_topic" {
  type        = bool
  default     = false
  description = "Whether to create an SNS topic for pushing Config notifications"
}

variable "tags" {
  type        = map(string)
  description = "A list of tags to apply to resources created by this module"

  validation {
    condition     = contains(keys(var.tags), "team")
    error_message = "A 'team' tag must be specified."
  }

  validation {
    condition     = contains(keys(var.tags), "impact")
    error_message = "An 'impact' tag must be specified."
  }

  validation {
    condition     = contains(keys(var.tags), "service")
    error_message = "A 'service' tag must be specified."
  }
}
