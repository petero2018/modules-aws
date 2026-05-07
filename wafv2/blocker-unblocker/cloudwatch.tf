resource "aws_cloudwatch_event_rule" "waf_updater" {
  name        = "WAF-Unblocker"
  description = "Run WAF-Unblocker Lambda every minute"

  schedule_expression = "rate(1 minute)"

  is_enabled = var.enable_unblocker_schedule

  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }
}

resource "aws_cloudwatch_event_target" "waf_updater" {
  target_id = "WAF-Unblocker"
  rule      = aws_cloudwatch_event_rule.waf_updater.name
  arn       = aws_lambda_function.waf_updater.arn
}
