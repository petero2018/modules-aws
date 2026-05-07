variable "dns_zone_id" {
  description = "Route53 Zone id handling the domains on the certificate"
  type        = string
}

variable "domain_name" {
  description = "Main domain name for the SSL certificate"
  type        = string
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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "dns_ttl" {
  description = "DNS records TTL"
  type        = number
  default     = 60
}

variable "subject_alternative_names" {
  description = "Alternate domain names  for the SSL certificate"
  type        = list(string)
  default     = []
}

variable "enable_dns_validation" {
  description = "Enable DNS validation for the certificate"
  type        = bool
  default     = true
}
