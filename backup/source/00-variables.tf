variable "environment" {
  type        = string
  description = "Environment name."
}

variable "vault_name" {
  type = string

  description = "Name for AWS Backup vaults."
}

variable "tags" {
  type    = map(string)
  default = { "team" = "product-infrastructure", "impact" = "critical", "service" = "disaster-recovery" }

  description = "Tags on AWS Backup related resources."
}

variable "dynamodb_selection_tag" {
  type    = string
  default = "dynamodb_daily"

  description = "Value for tag to target DynamoDB resources for backups. Defaults to \"dynamodb_daily\""
}

variable "rds_selection_tag" {
  type    = string
  default = "rds_daily"

  description = "Value for tag to target RDS resources for backups. Defaults to \"rds_daily\""
}

variable "s3_selection_tag" {
  type    = string
  default = "s3_backup"

  description = "Value for tag to target S3 resources for backups. Defaults to \"s3_backup\""
}

variable "backup_role_arn" {
  type = string

  description = "ARN of the IAM role used for AWS Backup."
}

variable "backup_account_id" {
  type = number

  description = "AWS Account ID for the backup account."
}

variable "backup_retention_days" {
  type    = number
  default = 15

  description = "Number of days to retain backups in the vault."

  validation {
    condition     = var.backup_retention_days >= 15
    error_message = "Number of days to retain backups must not be less that 15 for complaince."
  }
}

variable "destination_region" {
  type = string

  description = "Region to copy backups to in main account."
}

variable "backup_vault_arn" {
  type = string

  description = "ARN for the AWS Backup Vault in the region backups are copied to in the main account."
}

variable "destination_region_vault_arn" {
  type = string

  description = "ARN for the AWS Backup Vault in the region backups are copied to in the main account."
}

variable "vault_kms_key_arn" {
  type = string

  description = "Primary KMS key used to encrypt AWS Backups."
}
