variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM certificate ARN to use."
}

variable "description" {
  type        = string
  description = "Description of the CloudFront distribution."
}

variable "domain_names" {
  type        = list(string)
  default     = []
  description = "List of domain name aliases for the distribution."
}

variable "route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 Zone ID where to create domains for the Cloudfront distribution, optional."
}

variable "http_version" {
  type        = string
  default     = "http2and3"
  description = "Supported HTTP protocols."
}

variable "web_acl_id" {
  type        = string
  default     = null
  description = "Web ACL (WAF) ID to attach to the distribution."
}

variable "logging_bucket_fqdn" {
  type        = string
  description = "Logging bucket FQDN, e.g. 'bucket.s3.amazonaws.com'."
}

variable "logging_prefix" {
  type        = string
  description = "Prefix for storing logs in the logging bucket, e.g. 'my-distro'."
}

variable "custom_cache_policies" {
  # Default values are taken from the Managed-CachingOptimized config: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized
  type = map(object({
    min_ttl     = optional(number, 1)
    max_ttl     = optional(number, 31536000)
    default_ttl = optional(number, 86400)
    comment     = optional(string)
    cookies = optional(object({
      behavior = optional(string, "none")
      list     = optional(list(string), null)
    }), {})
    headers = optional(object({
      behavior = optional(string, "none")
      list     = optional(list(string), null)
    }), {})
    query_strings = optional(object({
      behavior = optional(string, "none")
      list     = optional(list(string), null)
    }), {})
    enable_brotli = optional(bool, true)
    enable_gzip   = optional(bool, true)
  }))
  default     = {}
  description = "Map of custom cache policies to create: cache policy name => parameters."

  validation {
    condition     = alltrue([for policy_name, config in var.custom_cache_policies : !startswith("Managed-", policy_name)])
    error_message = "Custom cache policy names cannot start with 'Managed-', as these are reserved for AWS managed cache policies."
  }
}

variable "default_behavior" {
  type = object({
    origin                 = string
    cache_policy           = optional(string, "Managed-CachingOptimized")
    allowed_methods        = optional(list(string), ["GET", "HEAD"])
    cached_methods         = optional(list(string), ["GET", "HEAD"])
    compress               = optional(bool, true)
    viewer_protocol_policy = optional(string, "redirect-to-https")
  })
  description = "Default cache behavior of the distribution."
}

variable "custom_origins" {
  type = map(object({
    domain_name       = string
    http_port         = optional(number, 80)
    https_port        = optional(number, 443)
    protocol_policy   = optional(string, "https-only")
    ssl_protocols     = optional(list(string), ["TLSv1.2"])
    keepalive_timeout = optional(number, 5)
    read_timeout      = optional(number, 30)
  }))
  description = "Map of custom origins: origin ID => origin config."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to AWS resources."

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}
