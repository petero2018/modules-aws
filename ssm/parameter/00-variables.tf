variable "name" {
  type        = string
  description = "SSM parameter name."
}

variable "value" {
  type        = string
  description = "SSM parameter value."
  default     = null

  sensitive = true
}

variable "insecure_value" {
  type        = string
  description = "Insecure SSM parameter value."
  default     = null

  sensitive = false
}

variable "dynamic" {
  type        = bool
  description = "Whether the SSM parameter's value will be managed outside of Terraform or not."
  default     = false
}

variable "dynamic_initial_value" {
  type        = string
  description = "The initial value to set when creating a dynamic SSM parameter, which will be thereafter replaced by an external process."
  default     = "-"
}

variable "description" {
  type        = string
  description = "SSM parameter description."
}

variable "type" {
  type        = string
  description = "SSM parameter type."
  default     = "SecureString"
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
