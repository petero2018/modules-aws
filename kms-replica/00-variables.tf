variable "primary_key_arn" {
  type        = string
  description = "The ARN of the primary KMS key."
}

variable "deletion_window_in_days" {
  type        = number
  default     = 14
  description = "Duration in days after which the key is deleted after destruction of the resource."
}

variable "description" {
  type        = string
  description = "The description of the key as viewed in AWS console."
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the key is enabled."
}

variable "key_policy" {
  type        = string
  default     = null
  description = "Resource policy to grant use of the KMS key."
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
