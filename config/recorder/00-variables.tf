variable "delivery_channel_config" {
  type = object({
    bucket_name   = string
    sns_topic_arn = optional(string)
  })
  description = "The bucket and SNS topic to which AWS Config will send results"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to enable AWS Config recorder"
}

variable "create_service_linked_role" {
  type        = bool
  default     = false
  description = "Whether to create the required IAM Service Linked Role for AWS Config. This should almost always be false as the role is created by Organizations"
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
