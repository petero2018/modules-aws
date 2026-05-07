resource "aws_backup_vault" "vault" {
  name        = var.vault_name
  kms_key_arn = var.vault_kms_key_arn

  tags = var.tags
}

resource "aws_backup_vault_lock_configuration" "backup_account" {
  count = var.lock_vault ? 1 : 0

  backup_vault_name   = aws_backup_vault.vault.name
  changeable_for_days = var.lock_changeable_days
  max_retention_days  = var.backup_retention_days
  min_retention_days  = var.backup_retention_days

  depends_on = [aws_backup_vault.vault]
}

resource "aws_backup_vault_policy" "backup_account" {
  count = var.vault_type == "backup" ? 1 : 0

  # Allow main US & EU vaults to copy into Backup EU vault
  backup_vault_name = aws_backup_vault.vault.name
  policy            = data.aws_iam_policy_document.allow_copy_into_backup.json
}

data "aws_iam_policy_document" "allow_copy_into_backup" {
  #checkov:skip=CKV_AWS_111:Policy is fine
  #checkov:skip=CKV_AWS_356:Policy is fine
  statement {
    sid = "Allow copy into Backup vault"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.source_account_id}:root",
      ]
    }
    actions = [
      "backup:CopyIntoBackupVault",
    ]
    resources = ["*"]
  }
}
