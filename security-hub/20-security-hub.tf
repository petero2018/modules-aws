resource "aws_securityhub_account" "default" {
  count = var.enable_security_hub ? 1 : 0

  control_finding_generator = "STANDARD_CONTROL"
  enable_default_standards  = var.enable_default_standards
}

resource "aws_securityhub_standards_subscription" "standards" {
  for_each = toset(concat(local.default_security_standards, var.extra_standards_arns))

  standards_arn = each.value
}

resource "aws_securityhub_finding_aggregator" "aggregator" {
  count        = var.aggregate_security_hub_regions ? 1 : 0
  linking_mode = "ALL_REGIONS"
}
