resource "aws_cloudwatch_log_group" "lambda_rds_copy" {
  #checkov:skip=CKV_AWS_158:We don't want to manage a KMS key just to encrypt these logs
  #checkov:skip=CKV_AWS_338:Disable retention days check

  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 30

  tags = var.tags

}
