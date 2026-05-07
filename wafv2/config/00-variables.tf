variable "scope" {
  type        = string
  description = "Whether the IP sets and rule groups are regional (i.e. us-east-1, eu-west-1 etc) or global (CloudFront)."
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Invalid scope. Only valid values are 'REGIONAL' and 'CLOUDFRONT'"
  }
}

variable "allowed_ips" {
  type = object({
    ipv4 = optional(list(string), [])
    ipv6 = optional(list(string), [])
  })
  description = "Extra IPs to allow through the WAF ACL."
  default     = {}
}

variable "blocked_ips" {
  type = object({
    ipv4 = optional(list(string), [])
    ipv6 = optional(list(string), [])
  })
  description = "Extra IPs to allow through the WAF ACL."
  default     = {}
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
