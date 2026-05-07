variable "manifests_bucket_arn" {
  type = string

  description = "Bucket arn for replication job manifests."
}

variable "reports_bucket_arn" {
  type = string

  description = "Bucket arn to store replication reports."
}

variable "tags" {
  type    = map(string)
  default = { "team" = "product-infrastructure", "impact" = "critical", "service" = "disaster-recovery" }

  description = "Tags on AWS Backup related resources."
}
