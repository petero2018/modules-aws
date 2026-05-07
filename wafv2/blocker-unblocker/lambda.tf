locals {
  lambda_runtime       = "python3.10"
  common_zip_filename  = "common-layer.zip"
  blocker_zip_filename = "waf-blocker.zip"
  updater_zip_filename = "waf-updater.zip"

  environment_variables = {
    ALLOW_IPSET_ARNS_IPV4         = join(",", var.allow_ipset_arns_ipv4)
    ALLOW_IPSET_ARNS_IPV6         = join(",", var.allow_ipset_arns_ipv6)
    BLOCK_IPSET_ARNS_IPV4         = join(",", var.block_ipset_arns_ipv4)
    BLOCK_IPSET_ARNS_IPV6         = join(",", var.block_ipset_arns_ipv6)
    DYNAMODB_BLOCKS_TABLE_NAME    = aws_dynamodb_table.waf_blocks.name
    DYNAMODB_BLOCKS_INDEX_NAME    = local.waf_blocks_gsi_name
    DYNAMODB_WHITELIST_TABLE_NAME = aws_dynamodb_table.waf_blocks_whitelist.name
    DYNAMODB_WHITELIST_INDEX_NAME = local.waf_blocks_whitelist_gsi_name
    PYTHONPATH                    = "/var/runtime:/opt" # Add /opt to import common layer
  }
}

data "archive_file" "common_layer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/common"
  excludes    = ["__pycache__"]
  output_path = local.common_zip_filename
}

data "archive_file" "lambda_blocker_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/blocker"
  excludes    = ["__pycache__"]
  output_path = local.blocker_zip_filename
}

data "archive_file" "lambda_updater_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/updater"
  excludes    = ["__pycache__"]
  output_path = local.updater_zip_filename
}

resource "aws_lambda_layer_version" "common" {
  layer_name = "WAF-Common-layer"

  filename         = local.common_zip_filename
  source_code_hash = data.archive_file.common_layer_zip.output_base64sha256

  compatible_runtimes = [local.lambda_runtime]
}

resource "aws_lambda_function" "waf_updater" {
  #checkov:skip=CKV_AWS_50:No need to use X-ray
  #checkov:skip=CKV_AWS_115:Default is to have no concurrent limit
  #checkov:skip=CKV_AWS_116:Logs can be seen in CloudWatch. DLQ not required
  #checkov:skip=CKV_AWS_117:Low risk. VPC not required
  #checkov:skip=CKV_AWS_173:Env variables are encrypted by default by a service key
  #checkov:skip=CKV_AWS_272:No need to validate code-signing
  filename         = local.updater_zip_filename
  source_code_hash = data.archive_file.lambda_updater_zip.output_base64sha256
  function_name    = "WAF-Updater"
  role             = aws_iam_role.waf_lambda_role.arn
  runtime          = local.lambda_runtime
  handler          = "lambda_function.lambda_handler"
  timeout          = 300
  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }

  layers = [aws_lambda_layer_version.common.arn]

  environment {
    variables = local.environment_variables
  }
}

resource "aws_lambda_function" "waf_blocker" {
  #checkov:skip=CKV_AWS_50:No need to use X-ray
  #checkov:skip=CKV_AWS_115:Default is to have no concurrent limit
  #checkov:skip=CKV_AWS_116:Logs can be seen in CloudWatch. DLQ not required
  #checkov:skip=CKV_AWS_117:Low risk. VPC not required
  #checkov:skip=CKV_AWS_173:Env variables are encrypted by default by a service key
  #checkov:skip=CKV_AWS_272:No need to validate code-signing
  filename         = local.blocker_zip_filename
  source_code_hash = data.archive_file.lambda_blocker_zip.output_base64sha256
  function_name    = "WAF-Blocker"
  role             = aws_iam_role.waf_lambda_role.arn
  runtime          = local.lambda_runtime
  handler          = "lambda_function.lambda_handler"
  timeout          = 300
  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }

  layers = [aws_lambda_layer_version.common.arn]

  environment {
    variables = local.environment_variables
  }
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.waf_blocker.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.waf_ips.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.waf_updater.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.waf_updater.arn
}
