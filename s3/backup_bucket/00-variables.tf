variable "src_bucket_name" {
  type        = string
  description = "Name of the source bucket to back up."
}

variable "add_random_suffix" {
  type        = bool
  default     = false
  description = "Whether to add a random string to bucket name to make it unique. Defaults to false."
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

variable "enable_storage_class_transition" {
  type        = bool
  default     = false
  description = "Whether to enable storage class transition lifecycle rule."
}

variable "storage_class_transition_days" {
  type        = number
  default     = 1
  description = "Number of days after which the storage class transition should happen."
}

variable "storage_class" {
  type        = string
  default     = "GLACIER_IR"
  description = "The target storage class after the lifecycle transition rule execution."
  # Not validating storage class values as they can evolve and the AWS provider will catch mistakes
}

variable "expire_noncurrent" {
  type        = bool
  default     = true
  description = "Whether to expire non-current objects (i.e. with a delete marker)."
}

variable "noncurrent_transition_days" {
  type        = number
  default     = 7
  description = "Number of days before expiring non-current objects, if enabled."
}
