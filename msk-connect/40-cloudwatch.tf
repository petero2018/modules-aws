resource "aws_cloudwatch_log_group" "connect_logs" {
  #checkov:skip=CKV_AWS_338:We don't want to retain logs for a year
  #checkov:skip=CKV_AWS_158:We don't need to encrypt these logs with KMS

  name = local.cloudwatch_log_group_name

  retention_in_days = var.cloudwatch_logs_retention_days

  tags = var.tags
}
