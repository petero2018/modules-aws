################################################################################
# Bucket
################################################################################

variable "bucket_name" {
  type        = string
  description = "Name of the bucket you wish to create."
}

variable "force_destroy" {
  type        = bool
  description = "Indicates all objects should be deleted from the bucket so that it can be destroyed without error."
  default     = false
}

variable "rand_suffix" {
  type        = bool
  description = "Whether to add random suffix to end of bucket name to make it globally unique. Defaults to false."
  default     = false
}

variable "ssm_identifier" {
  type        = string
  description = "Name to use to generate SSM parameter names to store the bucket name and ARN (optional)."
  default     = null
}

################################################################################
# CORS
################################################################################

variable "cors_configuration" {
  type = map(object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default     = null
  description = "Optional list of configurations for cors rules"
}

################################################################################
# Versioning
################################################################################

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Enable versioning on objects stored in the bucket."
}

################################################################################
# ACL
################################################################################

variable "object_ownership_setting" {
  type        = string
  description = "Controls ownership of objects uploaded to the bucket. If set to BucketOwnerEnforced, all ACLs are ignored for the purposes of determining access and only resource and/or identity policies will determine access to the bucket and its objects."
  default     = "BucketOwnerEnforced"

  validation {
    condition = contains([
      "BucketOwnerEnforced",
      "BucketOwnerPreferred",
      "ObjectWriter",
    ], var.object_ownership_setting)
    error_message = "Object ownership must be set to one of 'BucketOwnerEnforced', 'BucketOwnerPreferred' or 'ObjectWriter'."
  }
}

variable "acl" {
  type        = string
  description = "The canned ACL to apply to the bucket."
  default     = null

  validation {
    condition = anytrue([
      var.acl == "private",
      var.acl == "public-read",
      var.acl == "public-read-write",
      var.acl == "aws-exec-read",
      var.acl == "authenticated-read",
      var.acl == "bucket-owner-read",
      var.acl == "bucket-owner-full-control",
      var.acl == "log-delivery-write",
      var.acl == null
    ])
    error_message = "Not a valid canned ACL. Refer to https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl."
  }
}

variable "acl_policy_grants" {
  type = list(object({
    grants = map(object({
      id         = optional(string)
      type       = optional(string)
      uri        = optional(string)
      permission = optional(string)
    })),
    owner_id = optional(string)
  }))
  default     = null
  description = "Optional list of configurations for acl"
}

################################################################################
# Public Access
################################################################################

variable "public_access_block" {
  type = object({
    ignore_public_acls      = optional(bool)
    block_public_policy     = optional(bool)
    block_public_acls       = optional(bool)
    restrict_public_buckets = optional(bool)
  })
  default = {
    ignore_public_acls  = true # Ignore public ACLs on this bucket and any objects that it contains.
    block_public_policy = true # Reject s3:PutBucketPolicy calls if this bucket's policy allows public access.
    block_public_acls   = true
    # Reject s3:PutBucketAcl and s3:PutObjectAcl calls if this bucket's ACL allows public access.
    restrict_public_buckets = true
    # Only the bucket owner and AWS Services can access this bucket if it has a public policy. Set to false to allow cross-account actions.
  }
  description = "Options to block public access to the bucket."
}

################################################################################
# Bucket Policy
################################################################################

variable "create_bucket_policy" {
  type        = bool
  default     = true
  description = "Whether to create the bucket policy in this module."
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

################################################################################
# Website
################################################################################

variable "website_configuration" {
  type = object({
    index_document = optional(string)
    error_document = optional(string)
    redirect = optional(object({
      domain   = string
      protocol = optional(string, "https")
    }))
    routing_rules = optional(list(object({
      Condition = object({
        KeyPrefixEquals = string
      })
      Redirect = object({
        HostName             = string
        Protocol             = optional(string, "https")
        ReplaceKeyWith       = optional(string)
        ReplaceKeyPrefixWith = optional(string)
      })
    })))
  })
  default     = null
  description = "Options for website configuration of the bucket."
}

################################################################################
# Encryption
################################################################################

variable "encryption_at_rest" {
  type = object({
    bucket_key_enabled = optional(bool, true)
    encryption_settings = optional(object({
      sse_algorithm     = optional(string, "AES256")
      kms_master_key_id = optional(string)
    }), {})
  })
  default     = {}
  description = "Encryption at rest settings for the bucket."
}

################################################################################
# Logging
################################################################################

variable "logging_enabled" {
  type        = bool
  description = "Whether to enable access logs sent to the logs AWS account."
  default     = false
}

variable "logging_bucket" {
  type        = string
  description = "Bucket to store the logs"
  default     = ""
}

variable "logging_prefix" {
  type        = string
  description = "Prefix to add to the bucket logging"
  default     = ""
}

################################################################################
# Lifecycle
################################################################################

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "transition_default_minimum_object_size" {
  description = "The default minimum object size behavior applied to the lifecycle configuration."
  type        = string
  default     = "all_storage_classes_128K"

  validation {
    condition = contains([
      "all_storage_classes_128K",
      "varies_by_storage_class",
    ], var.transition_default_minimum_object_size)
    error_message = "Minimum object size must be set to one of 'all_storage_classes_128K' or 'varies_by_storage_class'."
  }
}

################################################################################
# Object Lock
################################################################################

variable "object_lock_config" {
  type = object({
    expected_bucket_owner = optional(string)
    token                 = optional(string)
    # Only required when enabling object lock on a bucket that was created without it. AWS Support has to provide this token.
    default_retention = object({
      mode  = string
      days  = optional(number)
      years = optional(number)
    })
  })
  description = "Configuration for the bucket's object lock."
  default     = null

  validation {
    condition = (
      var.object_lock_config == null ? true : (
        # One of the following two has to be set. Both cannot be empty or set at the same time. AKA XOR
        (var.object_lock_config.default_retention.days == null ? false : (
          var.object_lock_config.default_retention.days >= 1 &&
        var.object_lock_config.default_retention.years == null)) ||

        (var.object_lock_config.default_retention.years == null ? false : (
          var.object_lock_config.default_retention.years >= 1 &&
        var.object_lock_config.default_retention.days == null))
      )
    )
    error_message = "Invalid default retention timeframe. Only 'date' or 'years' must be set to an integer greater than 1, not both or neither."
  }

  validation {
    condition = (
      var.object_lock_config == null ||
      try(var.object_lock_config.default_retention.mode, "") == "COMPLIANCE" || try(var.object_lock_config.default_retention.mode, "") == "GOVERNANCE"
    )
    error_message = "Invalid retention mode. Only valid values are 'COMPLIANCE' or 'GOVERNANCE'."
  }
}

variable "metric_config" {
  type = map(object({
    prefix = optional(string, "")
    tags   = optional(map(string), {})
    }
  ))

  description = "Metrics to enable on the bucket."
  default     = {}

  validation {
    condition = (
      length(var.metric_config) == 0 ||
    alltrue([for filter in var.metric_config : false if sum([length(filter.tags), length([filter.prefix])]) > 10]))
    error_message = "Tag limit exceeded. The maximum number of tags per filter is 10 (9 if 'prefix' is set)."
  }
}

################################################################################
# Cloudfront
################################################################################

variable "enable_cloudfront" {
  type        = bool
  default     = false
  description = "Whether to create a simple read-only Cloudfront distribution with this bucket as the origin."
}

variable "cloudfront_domains" {
  type        = list(string)
  default     = []
  description = "List of domains accepted by the Cloudfront distribution."
}

variable "cloudfront_ipv6_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable IPv6 on the Cloudfront distribution."
}

variable "cloudfront_certificate_arn" {
  type        = string
  default     = null
  description = "ARN of the ACM certificate to use for the Cloudfront distribution."
}

variable "cloudfront_web_acl_arn" {
  type        = string
  default     = null
  description = "Web ACL (WAF) ARN to use in front of the Cloudfront distribution."
}

variable "cloudfront_route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 Zone ID where to create domains for the Cloudfront distribution, optional."
}

variable "cloudfront_custom_origins" {
  type = map(object({
    domain_name            = string
    connection_attempts    = optional(number, 3)
    connection_timeout     = optional(number, 10)
    http_port              = optional(number, 80)
    https_port             = optional(number, 443)
    origin_protocol_policy = optional(string, "https-only")
    origin_ssl_protocols   = optional(list(string), ["TLSv1", "TLSv1.1", "TLSv1.2"])
  }))
  default     = {}
  description = "Map of CloudFront custom origins: origin ID => configuration."
}

variable "cloudfront_default_cache_behavior_options" {
  type = object({
    allowed_methods = optional(list(string), ["GET", "HEAD"])
    cached_methods  = optional(list(string), ["GET", "HEAD"])
    default_ttl     = optional(number, 300)
  })
  default     = {}
  description = "Options for the CloudFront defautl cache behavior."
}

variable "cloudfront_cache_behaviors" {
  type = list(object({
    target_origin_id       = string
    path_pattern           = string
    allowed_methods        = optional(list(string), ["GET", "HEAD"])
    cached_methods         = optional(list(string), ["GET", "HEAD"])
    max_ttl                = optional(number, 31536000)
    min_ttl                = optional(number, 0)
    viewer_protocol_policy = optional(string, "redirect-to-https")
    forwarded_headers      = optional(list(string), ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"])
    response_headers_policy = optional(object({
      name    = string
      comment = string
      custom_headers_config = optional(map(object({
        override = bool
        value    = string
      })), {})
    }), null)
  }))
  default     = []
  description = "List of CloudFront ordered cache behaviors."
}

variable "cloudfront_cors_config" {
  type = object({
    origin_override                  = optional(bool, true)
    access_control_allow_credentials = optional(bool, false)
    access_control_allow_headers     = optional(list(string), ["*"])
    access_control_allow_methods     = optional(list(string), ["GET", "HEAD"])
    access_control_allow_origins     = list(string)
  })
  description = "CloudFront CORS settings."
  default     = null
}

################################################################################
# Backup
################################################################################

variable "aws_backup_enabled" {
  type        = bool
  default     = false
  description = "Adds a new tag to enable AWS backups."
}


################################################################################
# Tags
################################################################################

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
