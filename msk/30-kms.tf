data "aws_iam_policy_document" "kms" {
  #checkov:skip=CKV_AWS_111:Is to be used by CW logs so we can trust AWS?
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.cloudwatch_logs_log_group}"]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
}

module "kms" {
  #checkov:skip=CKV_AWS_356:Policy follows recommendation

  count = var.kms_key_arn == null ? 1 : 0

  source = "../kms"

  alias       = "msk-${local.full_name}"
  description = "Key for MSK cluster ${local.full_name}"

  key_policy = data.aws_iam_policy_document.kms.json

  tags = local.tags
}

data "aws_iam_policy_document" "kms_secrets_manager" {
  # See https://docs.aws.amazon.com/secretsmanager/latest/userguide/security-encryption.html#security-encryption-policies
  #checkov:skip=CKV_AWS_356:Policy follows recommendation
  #checkov:skip=CKV_AWS_109:Policy follows recommendation

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "kms:CallerAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:GenerateDataKey*",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "kms:CallerAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:RevokeGrant",
    ]
    resources = ["*"]
  }
}

module "kms_scram" {
  #checkov:skip=CKV_AWS_356:Policy follows recommendation

  count = length(var.scram_users) > 0 ? 1 : 0

  source = "../kms"

  alias       = "msk-scram-${local.full_name}"
  description = "Key to encrypt SCRAM credentials for MSK cluster ${local.full_name}"

  key_policy = data.aws_iam_policy_document.kms_secrets_manager.json

  tags = local.tags
}

locals {
  kms_key_arn = coalesce(var.kms_key_arn, module.kms[0].key_arn)
}
