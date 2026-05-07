resource "aws_route53_record" "record" {
  for_each = var.records != null ? var.records : {}

  name    = each.key
  records = each.value.records
  ttl     = each.value.ttl
  type    = each.value.record_type
  zone_id = each.value.zone_id
}

resource "aws_route53_record" "aliased_record" {
  #checkov:skip=CKV2_AWS_23: Because this is a module, a resource cannot be attached and this check will never be satisfied, so skipping

  for_each = var.alias_a_records != null ? var.alias_a_records : {}

  name    = each.key
  type    = "A"
  zone_id = each.value.zone_id

  alias {
    evaluate_target_health = each.value.evaluate_target_health
    name                   = each.value.alias_name
    zone_id                = each.value.hosted_zone_id
  }
}
