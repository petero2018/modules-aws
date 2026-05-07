variable "cluster_name" {
  type        = string
  description = "OpenSearch cluster name, used to name the snapshots IAM role."
}

variable "repositories" {
  type = map(object({
    bucket_name   = string
    bucket_region = string
    create_bucket = optional(bool, false)
    settings      = optional(map(string), {})
    snapshots = optional(object({
      enabled             = optional(bool, false)
      policy_name         = optional(string, "daily-snapshots")
      policy_description  = optional(string, "Daily cluster-wide snapshots")
      cron_expression     = optional(string, "0 4 * * *")
      cron_timezone       = optional(string, "UTC")
      time_limit          = optional(string, "2h")
      deletion_time_limit = optional(string, "2h")
      max_age             = optional(string, "15d")
      indices             = optional(string, "*")
      timezone            = optional(string, "UTC")
    }))
  }))
  description = "Map of { name => repository } of OpenSearch S3 snapshot repositories to set up."
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
