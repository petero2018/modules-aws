variable "account_name" {
  type        = string
  description = "Account name tag, e.g prod"
}

# AWS Shield Advanced
variable "force_enable_shield_srt_access" {
  type        = bool
  default     = false
  description = "Whether to enable the AWS Shield Response Team (SRT) access for this account/region regardless of its containing Org Unit."
}

variable "shield_advanced_org_unit_ids" {
  type = list(string)
  default = [
    "ou-5ngy-rqquo55k"
  ]
  description = "A list of Org Units which have Shield Advanced enabled."
}

variable "srt_bucket_names" {
  type        = list(string)
  default     = []
  description = "A list of buckets that this module will create, to be used to share information with AWS SRT. One should be created per engagement with SRT."

  validation {
    condition     = length(var.srt_bucket_names) <= 10
    error_message = "Only up to 10 SRT buckets can be created."
  }
}

variable "enable_proactive_engagement" {
  type        = bool
  default     = true
  description = "Whether to enable the AWS Shield Response Team (SRT) proactive engagement"
}

variable "override_proactive_engagement_contacts" {
  type = map(object({
    phone_number  = optional(string),
    contact_notes = optional(string)
  }))
  description = "Override the default proactive engagement contacts."
  default     = {}
  nullable    = false
}

variable "additional_proactive_engagement_contacts" {
  type = map(object({
    phone_number  = optional(string)
    contact_notes = optional(string)
  }))
  description = "A list of additional teams who will be contacted by AWS SRT in the event of an identified issue."
  default     = {}
  nullable    = false
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
