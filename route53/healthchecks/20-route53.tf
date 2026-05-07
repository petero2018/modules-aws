locals {
  create_aggregated_health_check = var.aggregated_health_check_name != ""
}

resource "aws_route53_health_check" "example" {
  for_each = var.healthchecks

  failure_threshold = each.value.failure_threshold
  fqdn              = each.value.domain
  port              = each.value.port
  request_interval  = each.value.interval
  resource_path     = each.value.path
  type              = each.value.type

  measure_latency = true

  tags = merge(
    var.tags,
    { Name = each.key },
    local.create_aggregated_health_check ? {
      aggregated = true,
      parent     = var.aggregated_health_check_name
    } : {}
  )
}

resource "aws_route53_health_check" "aggregated" {
  count = local.create_aggregated_health_check ? 1 : 0

  type = "CALCULATED"

  child_healthchecks     = [for hc in aws_route53_health_check.example : hc.id]
  child_health_threshold = var.aggregated_health_check_threshold > 0 ? var.aggregated_health_check_threshold : length(aws_route53_health_check.example)

  tags = merge(
    var.tags,
    {
      Name = var.aggregated_health_check_name
    }
  )
}
