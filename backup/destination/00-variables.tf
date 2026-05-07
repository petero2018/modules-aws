variable "vault_name" {
  type = string

  description = "Name for AWS Backup vaults."
}

variable "tags" {
  type    = map(string)
  default = { "team" = "product-infrastructure", "impact" = "critical", "service" = "disaster-recovery" }

  description = "Tags on AWS Backup related resources."
}

variable "lock_vault" {
  type    = bool
  default = false

  description = "Add a vault lock to the vault to prevent backup deletion."
}

variable "vault_type" {
  type = string

  default = "backup"

  description = "Whether the vault type is regional or a backup."

  validation {
    condition     = var.vault_type == "regional" || var.vault_type == "backup"
    error_message = "The value of vault_type must be either 'regional' or 'backup'."
  }
}

variable "vault_kms_key_arn" {
  type = string

  description = "Primary KMS key used to encrypt AWS Backups."
}

variable "backup_retention_days" {
  type    = number
  default = 15

  description = "Number of days to retain backups in the vault."

  validation {
    condition     = var.backup_retention_days >= 15
    error_message = "Number of days to retain backups must not be less that 15 for compliance."
  }
}

variable "source_account_id" {
  type = number

  description = "AWS Account ID of the account backups will be copied from."
}

variable "lock_changeable_days" {
  type        = number
  default     = 7
  description = "Number of grace days give to change the vault lock once set. Defaults to 7."
}
