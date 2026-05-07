locals {
  log_group_name = coalesce(var.log_group_name, "/opensearch/${var.domain}")
}

resource "aws_cloudwatch_log_group" "es_log_group" {
  #checkov:skip=CKV_AWS_158:We don't want to manage a KMS key just to encrypt these logs
  #checkov:skip=CKV_AWS_338:Retention period is actually set, might be a bug in checkov
  count = var.logs_enabled ? 1 : 0

  name              = local.log_group_name
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_resource_policy" "es_policy" {
  count = var.logs_enabled ? 1 : 0

  policy_name = "${var.domain}-opensearch"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.log_group_name}:log-stream:*",
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.log_group_name}"
      ]
    }
  ]
}
CONFIG
}
