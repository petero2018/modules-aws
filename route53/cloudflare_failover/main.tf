resource "aws_route53_record" "primary_record" {
  count = var.create_records ? 1 : 0

  name            = var.records.name
  records         = [var.records.record.primary]
  ttl             = var.records.ttl
  type            = var.records.type
  set_identifier  = "${var.records.name}_primary"
  health_check_id = aws_route53_health_check.primary_record_health_check.id
  zone_id         = var.records.zone_id

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "secondary_record" {
  count = var.create_records ? 1 : 0

  name            = var.records.name
  records         = [var.records.record.secondary]
  ttl             = var.records.ttl
  type            = var.records.type
  set_identifier  = "${var.records.name}_secondary"
  health_check_id = aws_route53_health_check.secondary_record_health_check.id
  zone_id         = var.records.zone_id

  failover_routing_policy {
    type = "SECONDARY"
  }
}

resource "aws_route53_health_check" "primary_record_health_check" {
  fqdn              = var.health_checks.fqdn.primary
  port              = var.health_checks.port
  type              = var.health_checks.type
  resource_path     = var.health_checks.resource_path
  failure_threshold = var.health_checks.failure_threshold
  request_interval  = var.health_checks.request_interval

  tags = var.tags
}

resource "aws_route53_health_check" "secondary_record_health_check" {
  fqdn              = var.health_checks.fqdn.secondary
  port              = var.health_checks.port
  type              = var.health_checks.type
  resource_path     = var.health_checks.resource_path
  failure_threshold = var.health_checks.failure_threshold
  request_interval  = var.health_checks.request_interval

  tags = var.tags
}
