variable "vault_name" {
  type = string

  description = "Name for the recovery AWS Backup vault."
}

variable "tags" {
  type    = map(string)
  default = { "team" = "product-infrastructure", "impact" = "critical", "service" = "disaster-recovery" }

  description = "Tags on AWS Backup related resources."
}

variable "aws_backup_account_id" {
  type = string

  description = "AWS Account ID of the Backup account."
}
