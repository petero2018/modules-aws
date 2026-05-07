variable "create_regional_ip_lists" {
  type        = bool
  default     = true
  description = "If true, this module creates and populates REGIONAL-scoped IPSets."
}

variable "create_cloudfront_ip_lists" {
  type        = bool
  default     = false
  description = "If true, this module creates and populates GLOBAL-scoped IPSets."
}
