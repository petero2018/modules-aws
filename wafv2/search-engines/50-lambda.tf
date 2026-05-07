data "archive_file" "lambda_search_engines_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "waf-search-engines.zip"
}

resource "aws_lambda_function" "waf_search_engines" {
  #checkov:skip=CKV_AWS_50:No need to use X-ray
  #checkov:skip=CKV_AWS_115:Default is to have no concurrent limit
  #checkov:skip=CKV_AWS_116:Logs can be seen in CloudWatch. DLQ not required
  #checkov:skip=CKV_AWS_117:Low risk. VPC not required
  #checkov:skip=CKV_AWS_173:Env variables are encrypted by default by a service key
  #checkov:skip=CKV_AWS_272:No need to validate code-signing
  filename         = "waf-search-engines.zip"
  source_code_hash = data.archive_file.lambda_search_engines_zip.output_base64sha256
  function_name    = local.lambda_function_name
  role             = aws_iam_role.waf_lambda_role_search_engines.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 300
  environment {
    variables = merge(
      # Regional IPSet ARNs
      var.create_regional_ip_lists ? {
        IPV4_REGIONAL_IPSET_ID   = aws_wafv2_ip_set.search_engines_ipv4_regional[0].id,
        IPV6_REGIONAL_IPSET_ID   = aws_wafv2_ip_set.search_engines_ipv6_regional[0].id,
        IPV4_REGIONAL_IPSET_NAME = aws_wafv2_ip_set.search_engines_ipv4_regional[0].name,
        IPV6_REGIONAL_IPSET_NAME = aws_wafv2_ip_set.search_engines_ipv6_regional[0].name,
      } : {},
      # Cloudfront IPSet ARNs (optional)
      var.create_cloudfront_ip_lists ? {
        IPV4_CLOUDFRONT_IPSET_ID   = aws_wafv2_ip_set.search_engines_ipv4_cloudfront[0].id,
        IPV6_CLOUDFRONT_IPSET_ID   = aws_wafv2_ip_set.search_engines_ipv6_cloudfront[0].id
        IPV4_CLOUDFRONT_IPSET_NAME = aws_wafv2_ip_set.search_engines_ipv4_cloudfront[0].name,
        IPV6_CLOUDFRONT_IPSET_NAME = aws_wafv2_ip_set.search_engines_ipv6_cloudfront[0].name,
      } : {}
    )
  }

  tags = local.tags
}

resource "aws_lambda_permission" "search_engine_allow_events" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.waf_search_engines.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.waf_search_engines_1h.arn
}

resource "aws_lambda_invocation" "trigger_on_create" {
  function_name = local.lambda_function_name

  input = jsonencode({}) # Lambda takes no input

  depends_on = [
    # Lambda function must be ready
    aws_lambda_function.waf_search_engines,
    aws_iam_role_policy_attachment.waf_lambda_policy_search_engines,
    # IP sets must exist before calling the lambda
    aws_wafv2_ip_set.search_engines_ipv4_regional,
    aws_wafv2_ip_set.search_engines_ipv6_cloudfront,
  ]
}
