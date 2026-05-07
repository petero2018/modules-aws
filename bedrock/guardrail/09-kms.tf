data "aws_iam_policy_document" "kms_policy" {
  # checkov:skip=CKV_AWS_111: '*' refers to the resource itself, not all resources
  # checkov:skip=CKV_AWS_356: '*' refers to the resource itself, not all resources
  # checkov:skip=CKV_AWS_109: '*' refers to the resource itself, not all resources
  count = var.enable_encryption ? 1 : 0

  statement {
    sid    = "PermissionsForGuardrailsUusers"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.guardrail_users
    }
    actions = [
      "kms:Decrypt",
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
    ]
    resources = ["*"]
  }
}

module "guardrail_key" {
  count = var.enable_encryption ? 1 : 0

  source = "../../kms"

  alias       = "bedrock/guardrail-${var.name}"
  description = "KMS Key for encrypting Bedrock Guardrail ${var.name}"

  # Optional: Key Policy
  key_policy = data.aws_iam_policy_document.kms_policy[0].json

  tags = var.tags
}
