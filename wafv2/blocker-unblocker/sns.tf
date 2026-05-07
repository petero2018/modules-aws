resource "aws_sns_topic" "waf_ips" {
  name              = "waf-ips"
  kms_master_key_id = aws_kms_key.sns_key.key_id

  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }
}

resource "aws_sns_topic_policy" "waf_ips" {
  arn    = aws_sns_topic.waf_ips.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "waf_ips" {
  topic_arn = aws_sns_topic.waf_ips.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.waf_blocker.arn
}
