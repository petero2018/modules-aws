variable "healthchecks" {
  type = map(
    object({
      domain            = string
      port              = optional(number, 443)
      path              = optional(string, "/")
      type              = optional(string, "HTTPS")
      interval          = optional(number, 10)
      failure_threshold = optional(number, 3)
    })
  )

  description = "Map of healthcheck configurations, map key is used as the Name tag on each healthcheck."
}

variable "aggregated_health_check_name" {
  type        = string
  default     = ""
  description = "If true, an additional health check will be created with this name, which aggregates all health checks in the healthchecks map."
  nullable    = false
}

variable "aggregated_health_check_threshold" {
  type        = number
  default     = 0
  description = "value of the child health threshold for the aggregated health check. If not set, or set to 0, it will be set to the length of the healthchecks map."
}

variable "tags" {
  type = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }

  description = "Tags on the healthcheck."
}
