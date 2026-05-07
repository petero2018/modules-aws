variable "force_destroy" {
  type        = bool
  description = "Indicates all objects should be deleted from the bucket so that it can be destroyed without error."
  default     = false
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

variable "public_access_block" {
  type = object({
    ignore_public_acls      = optional(bool)
    block_public_policy     = optional(bool)
    block_public_acls       = optional(bool)
    restrict_public_buckets = optional(bool)
  })
  default = {
    ignore_public_acls      = true
    block_public_policy     = true
    block_public_acls       = true
    restrict_public_buckets = true
  }
  description = "Options to block public access to the bucket."
}

variable "encryption_at_rest" {
  type = object({
    bucket_key_enabled = optional(bool)
    encryption_settings = object({
      sse_algorithm     = string
      kms_master_key_id = optional(string)
    })
  })
  default = {
    bucket_key_enabled = false
    encryption_settings = {
      kms_master_key_id = null
      sse_algorithm     = "AES256"
    }
  }
  description = "Encryption at rest settings for the bucket."
}

variable "deny_insecure_transport" {
  type        = bool
  description = "Whether to enable bucket policy to deny insecure transport in bucket policy."
  default     = true
}

variable "require_latest_tls" {
  type        = bool
  description = "Whether to enable bucket policy to require latest TLS in bucket policy."
  default     = true
}

variable "require_encrypted_uploads" {
  type        = bool
  description = "Whether to require encrypted uploads in bucket policy."
  default     = true
}
