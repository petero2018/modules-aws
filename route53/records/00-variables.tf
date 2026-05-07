variable "records" {
  type = map(object({
    zone_id     = string,
    records     = list(string),
    ttl         = number,
    record_type = string
  }))
  description = "Map of records to create."
  default     = null
}

variable "alias_a_records" {
  type = map(object({
    zone_id                = string
    alias_name             = string
    hosted_zone_id         = string
    evaluate_target_health = string
  }))
  description = "Map of aliased records to create."
  default     = null
}
