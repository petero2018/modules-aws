variable "name" {
  type        = string
  description = "Name of the IAM user."
}

variable "path" {
  type        = string
  default     = "/"
  description = "Path of the IAM user."
}

variable "policy_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM policy ARNs to attach to the user."
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
