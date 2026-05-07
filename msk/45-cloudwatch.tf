locals {
  cloudwatch_logs_log_group = var.cloudwatch_logs_log_group != null ? var.cloudwatch_logs_log_group : "/aws/msk/broker-logs-${local.full_name}"
}

resource "aws_cloudwatch_log_group" "logs" {
  #checkov:skip=CKV_AWS_338:We don't want to retain logs for a year
  name = local.cloudwatch_logs_log_group

  retention_in_days = var.cloudwatch_logs_retention_days
  kms_key_id        = local.kms_key_arn

  tags = local.tags
}
