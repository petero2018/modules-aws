resource "aws_backup_vault" "vault" {
  name        = var.vault_name
  kms_key_arn = var.vault_kms_key_arn

  tags = var.tags
}
