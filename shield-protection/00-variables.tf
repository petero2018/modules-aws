variable "name" {
  type        = string
  description = "The name of the protection to be created"
}

variable "protected_resource_arn" {
  type        = string
  description = "The arn of the resource to be protected by AWS Shield"
}

variable "application_layer_protection_mode" {
  type        = string
  default     = "BLOCK"
  description = "Whether application layer protection should be enabled. Valid values are 'BLOCK', 'COUNT' or 'DISABLED'"

  validation {
    condition     = contains(["BLOCK", "COUNT", "DISABLED"], var.application_layer_protection_mode)
    error_message = "application_layer_protection_mode must be one of 'BLOCK', 'COUNT' or 'DISABLED'"
  }
}

variable "health_check" {
  type = object({
    enabled = bool
    arn     = string
  })
  default = {
    enabled = false
    arn     = null
  }
  nullable    = false
  description = "The ARN of the Route53 healthcheck to associate with the protection"
}

variable "tags" {
  type        = map(string)
  description = "value of the tags to be applied to resources created by this module"

  validation {
    condition     = contains(keys(var.tags), "team")
    error_message = "value of the 'team' tag must be set"
  }

  validation {
    condition     = contains(keys(var.tags), "service")
    error_message = "value of the 'service' tag must be set"
  }

  validation {
    condition     = contains(keys(var.tags), "impact")
    error_message = "value of the 'impact' tag must be set"
  }
}
