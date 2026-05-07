data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "access_for_inventory" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.inventory_bucket.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }

    condition {
      test     = "ArnLike"
      values   = [var.bucket_arn]
      variable = "aws:SourceArn"
    }
  }
}
