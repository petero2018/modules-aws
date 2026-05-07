resource "aws_route53_record" "record" {
  # Transforms
  #   { "id" => ["r1", "r2"] }
  # into
  #   {
  #     "id_r1" => { zone_id = "id", name = "r1" },
  #     "id_r2" => { zone_id = "id", name = "r2" },
  #   }
  for_each = merge([
    for zone_id, records in var.route53_records : {
      for record in records : "${zone_id}_${record}" => {
        zone_id = zone_id,
        name    = record,
      }
    }
  ]...)

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = "A"

  alias {
    name                   = aws_globalaccelerator_accelerator.accelerator.dns_name
    zone_id                = aws_globalaccelerator_accelerator.accelerator.hosted_zone_id
    evaluate_target_health = true
  }
}
