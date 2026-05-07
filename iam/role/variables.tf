variable "name" {
  type = string

  description = "Name of the IAM role to create."
}

variable "path" {
  type = string

  default     = null
  description = "Path to the role."
}

variable "description" {
  type = string

  default     = null
  description = "Description of the role."
}

variable "assume_role_policy" {
  type = string

  description = "Policy that grants an entity permission to assume the role."
}

variable "attach_policies" {
  type = list(string)

  default     = []
  description = "List of existing IAM policy ARNs to attach to the IAM role."
}

variable "create_policies" {
  type = map(string)

  default     = {}
  description = "Inline IAM policies (<NAME>:<POLICY>) to create and attach to the IAM role."
}

variable "max_session_duration" {
  type = number

  default     = 3600
  description = "Maximum session duration (in seconds)."
}

variable "permissions_boundary" {
  type = string

  default     = null
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
}

variable "force_detach_policies" {
  type = bool

  default     = false
  description = "Specifies to force detaching any policies the role has before destroying it."
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
