resource "aws_cloudwatch_event_rule" "backup_completed" {
  name        = "AWSBackupCopyComplete"
  description = "Captures completion of a Backup copy into the backup region"

  event_pattern = jsonencode({
    source      = ["aws.backup"],
    detail-type = ["Copy Job State Change"],
    account = [{
      anything-but = var.backup_account_id
    }],
    detail = {
      state        = ["COMPLETED"],
      resourceType = ["RDS", "Aurora"]
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_rds_copy" {
  rule      = aws_cloudwatch_event_rule.backup_completed.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.rds_backup_copy.arn
}
