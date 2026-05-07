resource "aws_kms_key" "sns_key" {
  description         = "KMS key to be used by the waf-ips SNS topic. Not intended for multi-topic encryption."
  policy              = data.aws_iam_policy_document.sns_key_policy.json
  enable_key_rotation = true

  tags = {
    impact  = "High"
    service = "WAFv2"
    team    = "Security"
  }
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/waf-ips-sns"
  target_key_id = aws_kms_key.sns_key.key_id
}
