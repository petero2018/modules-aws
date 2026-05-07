resource "aws_backup_vault" "recovery" {
  name        = var.vault_name
  kms_key_arn = aws_kms_key.recovery.arn

  tags = var.tags
}

resource "aws_backup_vault_policy" "recovery" {
  # Allow backup EU vaults to copy into recovery Backup vault
  backup_vault_name = aws_backup_vault.recovery.name
  policy            = data.aws_iam_policy_document.allow_copy_into_recovery.json
}

data "aws_iam_policy_document" "allow_copy_into_recovery" {
  statement {
    sid = "Allow copy into recovery Backup vault"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_backup_account_id}:root",
      ]
    }
    actions = [
      "backup:CopyIntoBackupVault",
    ]
    resources = ["*"]
  }
}
