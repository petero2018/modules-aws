variable "bucket_name" {
  type        = string
  description = "Name of the bucket you wish to monitor. This is the source bucket that is being replicated."
}

variable "monitor_name" {
  type        = string
  default     = null
  description = "To override the default monitor name that will assume the bucket_name by default. Use this if the bucket name contains special characters."

  validation {
    condition = (
      var.monitor_name == null ||
      can(regex("^[a-zA-Z0-9/_-]+$", var.monitor_name))
    )
    error_message = "Monitor name contains illegal characters. Please set monitor name with characters [a-zA-Z0-9/_-]."
  }
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the bucket you wish to monitor. This is the source bucket that is being replicated."
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

variable "datadog_api_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "Datadog API key to use to call datadog's api."
}
