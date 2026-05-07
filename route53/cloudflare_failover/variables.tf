variable "create_records" {
  description = "Boolean to create Route 53 resource or not. Set to false if just testing health check before tying a failover record to it."
  type        = bool
  default     = true
}

variable "records" {
  description = "Parameters for the primary and the secondary records."
  type = object({
    name = string
    record = object({
      primary   = string
      secondary = string
    })
    ttl     = number
    type    = string
    zone_id = string
  })
  validation {
    condition     = contains(["A", "AAAA", "CAA", "CNAME", "DS", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT"], var.records.type)
    error_message = "Invalid type. Valid values are 'A', 'AAAA', 'CAA', 'CNAME', 'DS', 'MX', 'NAPTR', 'NS', 'PTR', 'SOA', 'SPF', 'SRV', 'TXT'."
  }
}

variable "health_checks" {
  description = "Parameters for the health checks associated with the primary and secondary record."
  type = object({
    fqdn = object({
      primary   = string
      secondary = string
    })
    port              = number
    type              = string
    resource_path     = optional(string)
    failure_threshold = number
    request_interval  = number
  })
  validation {
    condition     = contains(["HTTP", "HTTPS", "HTTP_STR_MATCH", "HTTPS_STR_MATCH", "TCP", "CALCULATED", "CLOUDWATCH_METRIC", "RECOVERY_CONTROL"], var.health_checks.type)
    error_message = "Invalid type. Valid values are 'HTTP', 'HTTPS', 'HTTP_STR_MATCH', 'HTTPS_STR_MATCH', 'TCP', 'CALCULATED', 'CLOUDWATCH_METRIC', 'RECOVERY_CONTROL'."
  }
  validation {
    condition     = var.health_checks.failure_threshold >= 1 && var.health_checks.failure_threshold <= 10
    error_message = "Invalid failure_threshold. Must be an integer between 1 and 10."
  }
  validation {
    condition     = var.health_checks.request_interval == 10 || var.health_checks.request_interval == 30
    error_message = "Invalid request_interval. Must be 10 (fast) or 30 (standard) seconds."
  }
  validation {
    condition     = var.health_checks.port >= 1 && var.health_checks.port <= 65535
    error_message = "Invalid port. Must be an integer between 1 and 65535."
  }
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
