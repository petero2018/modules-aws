resource "aws_sqs_queue" "queue" {
  name        = var.name
  name_prefix = var.name_prefix

  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  redrive_policy              = var.redrive_policy == null ? null : jsonencode(var.redrive_policy)
  redrive_allow_policy        = var.redrive_policy == null ? null : jsonencode(var.redrive_allow_policy)
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit

  sqs_managed_sse_enabled           = var.encryption_at_rest.sqs_managed_sse_enabled
  kms_master_key_id                 = try(var.encryption_at_rest.kms_sse.kms_master_key_id, null)
  kms_data_key_reuse_period_seconds = try(var.encryption_at_rest.kms_sse.kms_data_key_reuse_period_seconds, null)

  tags = var.tags
}

resource "aws_sqs_queue_policy" "queue_access_policy" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.combined_policy.json
}

data "aws_iam_policy_document" "combined_policy" {
  source_policy_documents = compact([
    var.deny_insecure_transport ? data.aws_iam_policy_document.deny_insecure_transport.json : "",
    var.access_policy != null ? var.access_policy : ""
  ])
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid    = "denyInsecureTransport"
    effect = "Deny"

    actions = [
      "sqs:*",
    ]

    resources = [
      aws_sqs_queue.queue.arn
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}
