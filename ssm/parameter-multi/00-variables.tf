variable "parameters" {
  type = map(object({
    value                 = optional(string, null)
    insecure_value        = optional(string, null)
    description           = optional(string) # Optional override of the global description variable
    type                  = optional(string, "SecureString")
    tags                  = optional(map(string), {}) # Will be merged with the global tags variable
    sensitive             = optional(bool, true)
    dynamic               = optional(bool, false)
    dynamic_initial_value = optional(string, "-")
  }))
  description = "SSM parameters to create, key is the parameter name."
}

variable "description" {
  type        = string
  default     = null
  description = "SSM parameter description."
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
