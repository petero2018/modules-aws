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
  description = "Description of the policy."
}

variable "policy" {
  type = string

  description = "The policy document. This is a JSON formatted string."
}

variable "roles_to_attach" {
  type = list(string)

  default     = []
  description = "Roles to attach policy."
}

variable "tags" {
  description = "Tags to identify resources ownership"
  type        = map(string)
  validation {
    condition     = alltrue([for tag in ["team", "impact", "service"] : contains(keys(var.tags), tag)])
    error_message = "\"tags\" must contain at least those tags: \"team\", \"impact\", \"service\"."
  }
}
