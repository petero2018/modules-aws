# Security Hub variables
variable "enable_security_hub" {
  type        = bool
  description = "Whether to manually enable Security Hub for the account. Normally this can be false and Security Hub will be enabled via AWS Organizations."
  default     = false
}

variable "aggregate_security_hub_regions" {
  type        = bool
  description = "Whether or not to aggreate findings from multiple AWS regions into one. Set to true in the master account, leave as false otherwise."
  default     = false
}

variable "enable_default_standards" {
  type        = bool
  description = "Whether to auto-enable default security controls."
  default     = true
}

variable "extra_standards_arns" {
  type        = list(string)
  default     = []
  description = "List of extra ARNs of security standards to enable. If empty, only the default list of standards will be enabled."
}

variable "tags" {
  type = map(string)
  default = {
    service = "security"
    team    = "security"
    impact  = "critical"
  }

  description = "Tags to apply to resources"

  validation {
    condition     = can(var.tags["impact"])
    error_message = "Tags must contain an impact tag."
  }

  validation {
    condition     = can(var.tags["service"])
    error_message = "Tags must contain a service tag."
  }

  validation {
    condition     = can(var.tags["team"])
    error_message = "Tags must contain a team tag."
  }
}
