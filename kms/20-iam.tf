data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "combined_policy" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.baseline_key_policy.json,
    var.key_policy != null ? var.key_policy : "",
    var.attach_common_key_policy && anytrue([
      length(local.common_encryption_roles) > 0,
      length(local.common_decryption_roles) > 0,
      length(local.common_admin_roles) > 0
    ]) ? data.aws_iam_policy_document.common_key_policy.json : "",
  ])
}

data "aws_iam_policy_document" "baseline_key_policy" {
  #checkov:skip=CKV_AWS_107: Credential exposure does not apply here.
  #checkov:skip=CKV_AWS_108: Data exfiltration is mitigated by disallowing administrative roles from using the key to decrypt.
  #checkov:skip=CKV_AWS_109: Asterisk in the resource block only affects the policy to which this policy is attached to.
  #checkov:skip=CKV_AWS_110: Key is tied to specific principals, which are in turn assigned specific actions.
  #checkov:skip=CKV_AWS_111: Asterisk in the resource block only affects the policy to which this policy is attached to.
  #checkov:skip=CKV_AWS_356: This policy is intended to be attached to a KMS key, so it is not a security risk.

  statement {
    sid = "Allow Terraform to update this key, but not use it"

    not_actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole"]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }
  statement {
    sid = "Allow admins to see the key, but not use it or modify it"

    actions = [
      "kms:Describe*",
      "kms:List*",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminRole"]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }
  statement {
    sid = "Allow security to audit key configuration"

    actions = [
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:ListAliases",
      "kms:ListGrants",
      "kms:ListKeyPolicies",
      "kms:ListKeys",
      "kms:ListResourceTags",
      "kms:GetKeyRotationStatus"
    ]

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SecurityAuditToolsRole",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/vanta-auditor",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/access-analyzer.amazonaws.com/AWSServiceRoleForAccessAnalyzer",
      ]
    }

    resources = ["*"] # i.e. the key to which the policy is attached
  }
}

data "aws_iam_policy_document" "common_key_policy" {
  #checkov:skip=CKV_AWS_107: Credential exposure does not apply here.
  #checkov:skip=CKV_AWS_108: Data exfiltration is mitigated by disallowing administrative roles from using the key to decrypt.
  #checkov:skip=CKV_AWS_109: Asterisk in the resource block only affects the policy to which this policy is attached to.
  #checkov:skip=CKV_AWS_110: Key is tied to specific principals, which are in turn assigned specific actions.
  #checkov:skip=CKV_AWS_111: Asterisk in the resource block only affects the policy to which this policy is attached to.

  dynamic "statement" {
    for_each = length(local.common_encryption_roles) > 0 ? ["_"] : []

    content {

      sid = "AllowEncryption"

      principals {
        type = "AWS"

        identifiers = local.common_encryption_roles
      }

      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:GenerateDataKey*",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = length(local.common_decryption_roles) > 0 ? ["_"] : []

    content {
      sid = "AllowDecryption"

      principals {
        type = "AWS"

        identifiers = local.common_decryption_roles
      }

      effect    = "Allow"
      actions   = ["kms:Decrypt", "kms:Describe*", "kms:Get*", "kms:List*"]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = length(local.common_admin_roles) > 0 ? ["_"] : []

    content {
      sid = "AllowAdministration"

      principals {
        type = "AWS"

        identifiers = local.common_admin_roles
      }

      effect    = "Allow"
      actions   = ["kms:*"]
      resources = ["*"]
    }
  }
}
