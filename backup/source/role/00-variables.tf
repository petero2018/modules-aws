variable "role_name" {
  type    = string
  default = "AWSBackupRole"

  description = "Name for AWS Backup role."
}

variable "tags" {
  type    = map(string)
  default = { "team" = "product-infrastructure", "impact" = "critical", "service" = "disaster-recovery" }

  description = "Tags on the IAM Role."
}
