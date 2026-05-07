# Event Notification (Lambda, SNS, SQS, EventBridge)
resource "aws_s3_bucket_notification" "bucket_notification" {
  count       = (var.lambda_notifications != null || var.sns_notifications != null || var.sqs_notifications != null) ? 1 : 0
  bucket      = var.bucket
  eventbridge = var.eventbridge

  dynamic "lambda_function" {
    for_each = var.lambda_notifications != null ? var.lambda_notifications : {}
    content {
      id                  = lambda_function.key
      events              = lambda_function.value.events
      lambda_function_arn = lambda_function.value.lambda_function_arn
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "queue" {
    for_each = var.sqs_notifications != null ? var.sqs_notifications : {}
    content {
      id            = queue.key
      events        = queue.value.events
      queue_arn     = queue.value.queue_arn
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications != null ? var.sns_notifications : {}
    content {
      id            = topic.key
      events        = topic.value.events
      topic_arn     = topic.value.topic_arn
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
    }
  }

  depends_on = [
    aws_lambda_permission.allow,
    aws_sqs_queue_policy.allow,
    aws_sns_topic_policy.allow,
  ]
}

# Lambda
resource "aws_lambda_permission" "allow" {
  for_each = (var.lambda_notifications != null && var.create_lambda_permission) ? var.lambda_notifications : {}

  statement_id_prefix = "AllowLambdaS3BucketNotification-"
  action              = "lambda:InvokeFunction"
  function_name       = each.value.function_name
  qualifier           = each.value.qualifier
  principal           = "s3.amazonaws.com"
  source_arn          = local.bucket_arn
  source_account      = each.value.source_account
}

# SQS Queue
data "aws_iam_policy_document" "sqs" {
  for_each = (var.sqs_notifications != null && var.create_sqs_policy) ? var.sqs_notifications : {}

  statement {
    sid = "AllowSQSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.queue_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.bucket_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow" {
  for_each = (var.sqs_notifications != null && var.create_sqs_policy) ? var.sqs_notifications : {}

  queue_url = each.value.queue_url
  policy    = data.aws_iam_policy_document.sqs[each.key].json
}

# SNS Topic
data "aws_iam_policy_document" "sns" {
  for_each = (var.sns_notifications != null && var.create_sns_policy) ? var.sns_notifications : {}

  statement {
    sid = "AllowSNSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.topic_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.bucket_arn]
    }
  }
}

resource "aws_sns_topic_policy" "allow" {
  for_each = (var.sns_notifications != null && var.create_sns_policy) ? var.sns_notifications : {}

  arn    = each.value.topic_arn
  policy = data.aws_iam_policy_document.sns[each.key].json
}
