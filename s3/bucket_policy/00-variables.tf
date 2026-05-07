variable "bucket_id" {
  type        = string
  description = "The S3 bucket ID."
}

variable "bucket_arn" {
  type        = string
  description = "The S3 bucket ARN."
}

variable "bucket_policy" {
  type        = string
  description = "Bucket policy to attach. Must be in JSON format."
  default     = null
}

variable "bucket_policy_template" {
  type = map(object({
    effect         = optional(string) # by default Allow
    principal_type = optional(string) # by default AWS
    principals     = list(string)
    actions        = list(string)
    paths          = optional(list(string)) # by default /*
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))

  default     = {}
  description = "Bucket policy template. useful when you don't know the bucket name."
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
  description = "Whether to require encrypted uploads in bucket policy. Since SSE is enabled always this is not always needed."
  default     = false
}

variable "attach_lb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ALB/NLB log delivery policy attached"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_arns" {
  description = "Allow these CloudFront distribution ARNs to access the bucket in the policy (optional)."
  type        = list(string)
  default     = []
}

variable "replication_role_arn" {
  description = "IAM replication role ARN, set this to the replication role for replication target buckets (optional)."
  type        = string
  default     = null
}

variable "allow_read_from_account_ids" {
  type        = list(number)
  description = "List of AWS account IDs that will be allowed to read the bucket."
  default     = []
}
