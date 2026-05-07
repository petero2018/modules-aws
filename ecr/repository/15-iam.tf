data "aws_caller_identity" "current" {}

locals {
  authorised_accounts = distinct(concat([data.aws_caller_identity.current.account_id], var.authorised_accounts))
}

data "aws_iam_policy_document" "repository_policy" {
  statement {
    sid = "AllowPull"

    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", local.authorised_accounts)
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]

    dynamic "condition" {
      for_each = var.use_additional_source_account_check ? [1] : []

      content {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = local.authorised_accounts
      }
    }
  }
}
