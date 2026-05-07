resource "aws_route53_zone" "zone" {
  #checkov:skip=CKV2_AWS_38:We are not enforcing DNSSEC at this time
  #checkov:skip=CKV2_AWS_39:We are not enforcing DNS query logging at this time

  name    = var.name
  comment = var.description
  tags    = var.tags

  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
    }
  }
}

resource "aws_route53_record" "ns" {
  for_each = var.ns_records

  name    = each.key
  records = each.value
  ttl     = 172800 # 48 hours
  type    = "NS"

  zone_id = aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "soa" {
  count   = var.soa_record != null ? 1 : 0
  name    = var.soa_record.name
  records = [var.soa_record.record]
  ttl     = 900
  type    = "SOA"

  zone_id = aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "txt" {
  for_each = var.txt_records

  name    = each.key
  records = each.value
  ttl     = 60
  type    = "TXT"

  zone_id = aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "caa" {
  for_each = var.caa_records

  name    = each.key
  records = each.value
  ttl     = 300
  type    = "CAA"

  zone_id = aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "cname" {
  for_each = var.external_cname_records

  name    = each.key
  records = each.value
  ttl     = 300
  type    = "CNAME"

  zone_id = aws_route53_zone.zone.zone_id
}
