variable "name" {
  type        = string
  description = "Name of the DynamoDB table."
}

variable "hash_key" {
  type        = string
  description = "Table hash key."
}

variable "range_key" {
  type        = string
  default     = null
  description = "Table range key (optional)."
}

variable "read_capacity" {
  type        = number
  default     = null
  description = "Read capacity units."
}

variable "write_capacity" {
  type        = number
  default     = null
  description = "Write capacity units."
}

variable "attributes" {
  type        = map(string)
  default     = {}
  description = "Map of attributes: name => type. Type must be 'S' (string), 'N' (number) or 'B' (boolean)."
}

variable "global_secondary_indices" {
  type = map(object({
    hash_key        = string,
    projection_type = string,
  }))
  default     = {}
  description = "Map of global secondary indices: name => settings."
}

variable "ttl" {
  type = object({
    attribute_name = optional(string)
    enabled        = optional(bool)
  })
  default     = null
  description = "Optional TTL settings."
}

variable "enable_point_in_time_recovery" {
  type        = bool
  default     = false
  description = "Whether to enable point in time recovery."
}

variable "create_iam_readwrite_policy" {
  type        = bool
  default     = false
  description = "Whether to create an IAM read/write policy for this table."
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "The billing mode for the table. Must be 'PROVISIONED' or 'PAY_PER_REQUEST'."

  validation {
    condition     = var.billing_mode == "PROVISIONED" || var.billing_mode == "PAY_PER_REQUEST"
    error_message = "Billing mode must be 'PROVISIONED' or 'PAY_PER_REQUEST'."
  }
}

variable "aws_backup_enabled" {
  type        = bool
  default     = false
  description = "Adds a new tag to enable AWS daily backups."
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
