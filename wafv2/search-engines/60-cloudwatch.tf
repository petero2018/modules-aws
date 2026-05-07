resource "aws_cloudwatch_event_rule" "waf_search_engines_1h" {
  name        = "WAF-Search-Engines-1h${local.name_suffix}"
  description = "Run WAF-Search-Engines Lambda every 1 hour"

  schedule_expression = "rate(1 hour)"

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "waf_search_engines_1h" {
  target_id = "WAF-Search-Engine${local.name_suffix}"
  rule      = aws_cloudwatch_event_rule.waf_search_engines_1h.name
  arn       = aws_lambda_function.waf_search_engines.arn
}
