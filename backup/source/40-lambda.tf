resource "aws_lambda_function" "rds_backup_copy" {
  #checkov:skip=CKV_AWS_173:Environment variables are not secrets
  #checkov:skip=CKV_AWS_116:No need for a Dead Letter Queue, backups can be re-triggered any time manually
  #checkov:skip=CKV_AWS_117:We don't really care about running this function in a specific VPC
  #checkov:skip=CKV_AWS_272:Disable validate code-signing check

  filename      = "lambda.zip"
  function_name = local.lambda_function_name
  description   = "Copies RDS backups into backup account."
  role          = aws_iam_role.lambda_rds_copy.arn
  handler       = "copy_rds_snapshot.lambda_handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "python3.9"

  reserved_concurrent_executions = 10

  environment {
    variables = {
      "IAM_BACKUP_ROLE_ARN"          = var.backup_role_arn
      "DESTINATION_BACKUP_VAULT_ARN" = var.backup_vault_arn
      "BACKUP_REGION"                = var.destination_region
      "BACKUP_RETENTION_DAYS"        = var.backup_retention_days
    }
  }

  tracing_config {
    mode = "PassThrough"
  }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_backup_copy.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.backup_completed.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "lambda.zip"
}
