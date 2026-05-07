resource "aws_sns_topic" "s3_replication_topic" {
  name              = local.sns_replication_topic_name
  policy            = data.aws_iam_policy_document.s3_replication_topic.json
  kms_master_key_id = module.sns_kms_sse.key_id
  tags              = var.tags
}

data "aws_iam_policy_document" "s3_replication_topic" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:sns:*:*:${local.sns_replication_topic_name}"]
    actions   = ["SNS:Publish"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [var.bucket_arn]
    }

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_notification" "s3_replication_notification" {
  bucket = var.bucket_name

  topic {
    topic_arn = aws_sns_topic.s3_replication_topic.arn
    events    = ["s3:Replication:*"]
  }
}

resource "aws_sns_topic_subscription" "s3_replication_subscription" {
  topic_arn = aws_sns_topic.s3_replication_topic.arn
  protocol  = "https"
  endpoint  = "https://app.datadoghq.com/intake/webhook/sns?api_key=${var.datadog_api_key}"
}


module "sns_kms_sse" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.0.3"

  alias       = "sns-s3-replication-${local.monitor_name}"
  description = "KMS Key for SNS S3 replication topic."

  key_policy = data.aws_iam_policy_document.sns_kms_sse.json

  tags = var.tags
}

data "aws_iam_policy_document" "sns_kms_sse" {
  #checkov:skip=CKV_AWS_111:Key administration is actually restricted as recommended: https://docs.aws.amazon.com/AmazonS3/latest/userguide/grant-destinations-permissions-to-s3.html#key-policy-sns-sqs
  statement {
    sid       = "AllowUseByS3"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}
