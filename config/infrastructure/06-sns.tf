resource "aws_sns_topic" "config_notifications" {
  # checkov:skip=CKV_AWS_26: "TODO: Add encryption"
  count = var.create_sns_topic ? 1 : 0

  name = join("-", compact([var.account_name, var.account_suffix, "config"]))

  tags = var.tags
}

resource "aws_sns_topic_policy" "allow_service_linked_role" {
  count = var.create_sns_topic ? 1 : 0

  arn    = aws_sns_topic.config_notifications[0].arn
  policy = data.aws_iam_policy_document.config_sns_notifications[0].json
}

data "aws_iam_policy_document" "config_sns_notifications" {
  count = var.create_sns_topic ? 1 : 0
  statement {
    sid = "AWSConfigSNSPolicy"

    actions = [
      "sns:Publish"
    ]

    resources = [
      aws_sns_topic.config_notifications[0].arn
    ]

    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}
