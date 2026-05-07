data "aws_iam_policy_document" "key_policy" {
  #checkov:skip=CKV_AWS_111:Only allows use the key from the Opensearch Service
  #checkov:skip=CKV_AWS_109:Only allows read access from Opensearch Service
  #checkov:skip=CKV_AWS_356:Wildcards are limited by conditions
  statement {
    sid = "Allow Amazon OpenSearch Service to describe the key directly"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "es.amazonaws.com"
      ]
    }
    resources = ["*"]
  }

  statement {
    sid = "Allow access through OpenSearch Service"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"] # limited later by conditions
    }
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "es.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

module "cmk" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.1.2"

  alias       = "opensearch/${var.domain}"
  description = "KMS CMK Used to encrypt the ${var.domain} opensearch cluster."

  key_policy = data.aws_iam_policy_document.key_policy.json

  tags = var.tags
}
