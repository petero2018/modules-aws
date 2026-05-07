resource "aws_kms_key" "recovery" {
  description             = "Used for the recovery AWS Backup vault"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  multi_region = true

  policy = data.aws_iam_policy_document.recovery.json

  tags = var.tags
}

resource "aws_kms_alias" "recovery" {
  name          = "alias/aws-backup-${var.vault_name}"
  target_key_id = aws_kms_key.recovery.key_id
}

data "aws_iam_policy_document" "recovery" {
  #checkov:skip=CKV_AWS_109:Key administration is actually restricted as recommended: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html
  #checkov:skip=CKV_AWS_111:Key administration is actually restricted as recommended: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html

  statement {
    sid = "Allow use of the key"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.recovery.account_id}:root",
        "arn:aws:iam::${var.aws_backup_account_id}:root",
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow grant"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.recovery.account_id}:root",
        "arn:aws:iam::${var.aws_backup_account_id}:root", # This is required to copy RDS backups from an account to the other
      ]
    }

    actions = [
      "kms:CreateGrant",
    ]
    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }

  statement {
    sid = "Allow Key Administration to admin roles"

    principals {
      type = "AWS"
      identifiers = [
        # Only recovery account can administrate
        "arn:aws:iam::${data.aws_caller_identity.recovery.account_id}:role/AdminRole",
        "arn:aws:iam::${data.aws_caller_identity.recovery.account_id}:role/TerraformRole",
      ]
    }

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]
    resources = ["*"]
  }
}
